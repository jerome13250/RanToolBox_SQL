--compte le nombre de TRX:
DROP TABLE IF EXISTS tmp_nokia2g_nb_trx;
CREATE TEMP TABLE tmp_nokia2g_nb_trx AS
SELECT 
  "nokia_TRX"."managedObject_distName_parent" AS "BTS_managedObject_distName", 
  COUNT("nokia_TRX"."managedObject_TRX") AS nb_trx
FROM 
  public."nokia_TRX"
GROUP BY
  "nokia_TRX"."managedObject_distName_parent";


--Liste les BCCH Nokia :
DROP TABLE IF EXISTS tmp_nokia2g_bcch;
CREATE TEMP TABLE tmp_nokia2g_bcch AS
SELECT
"nokia_BTS"."managedObject_distName" AS "BTS_managedObject_distName",
"nokia_TRX"."initialFrequency" AS bcch
FROM 
  public."nokia_BTS" LEFT JOIN "nokia_TRX"
  ON
	"nokia_BTS"."managedObject_distName" = "nokia_TRX"."managedObject_distName_parent"

WHERE
  "nokia_TRX"."channel0Type" IN ('4','5') --filtre sur le BCCH
;

--Liste les fréquences initiales des TRX sauf le BCCH : utile pour les cellules sans MA List
DROP TABLE IF EXISTS tmp_nokia2g_trxinitialfreqs;
CREATE TEMP TABLE tmp_nokia2g_trxinitialfreqs AS
SELECT
"nokia_BTS"."managedObject_distName" AS "BTS_managedObject_distName",
string_agg("nokia_TRX"."initialFrequency",'-' ORDER BY "nokia_TRX"."initialFrequency"::int) AS "Freq_List"
FROM 
  public."nokia_BTS" LEFT JOIN "nokia_TRX"
  ON
	"nokia_BTS"."managedObject_distName" = "nokia_TRX"."managedObject_distName_parent"

WHERE
  "nokia_TRX"."channel0Type" NOT IN ('4','5') --filtre sur le BCCH: Attention il vaudrait mieux créer une table temp de bcch au lieude cela
GROUP BY 
  "nokia_BTS"."managedObject_distName"
;

-- Creation de la table topologie 2g nokia:
DROP TABLE IF EXISTS t_topologie2g_nokia;
CREATE TABLE t_topologie2g_nokia AS

SELECT
  "nokia_BSC"."managedObject_distName" AS "BSC_managedObject_distName",
  "nokia_BSC"."managedObject_BSC",
  "nokia_BSC".name AS "BSC_name",
  "nokia_BCF"."managedObject_distName" AS "BCF_managedObject_distName",
  "nokia_BCF".name AS "BCF_name",
  "nokia_BCF"."siteTemplateDescription" AS "BCF_siteTemplateDescription",
  "nokia_BCF"."SBTSId",
  "nokia_BTS"."managedObject_distName" AS "BTS_managedObject_distName", 
  "nokia_BTS"."managedObject_BTS", 
  "nokia_BTS".name AS "BTS_name",
  right("nokia_BTS".name, 1) AS sectorid,
  "nokia_BTS"."adminState" AS "BTS_adminState", --1:ONLINE / 3:OFFLINE
  "nokia_BTS"."frequencyBandInUse", --0:GSM / 1:DCS
  "locationAreaIdMNC",
  "locationAreaIdMCC",
  "locationAreaIdLAC",
  rac,
  "cellId",
  "bsIdentityCodeNCC",
  "bsIdentityCodeBCC",
  tmp_nokia2g_bcch.bcch,
  tmp_nokia2g_nb_trx.nb_trx,
  CASE "nokia_BTS"."hoppingMode"
	WHEN '0' THEN 'Non-hopping'::text
	WHEN '1' THEN 'Baseband hopping'::text
	WHEN '2' THEN 'Radio Frequency hopping'::text
	ELSE 'ERROR'::text END AS "hoppingMode",
  CASE "nokia_BTS"."hoppingMode"
	WHEN '2' THEN NULL
	ELSE tmp_nokia2g_trxinitialfreqs."Freq_List" END AS "Freq_List",
  "nokia_BTS"."usedMobileAllocation",
   string_agg("nokia_MAL_frequency".p_noname,'-' ORDER BY p_noname::int) AS "MA_List" --le ORDER BY sert à ordonner les fréquences
FROM 
  public."nokia_BTS" INNER JOIN "nokia_BCF"
  ON
	"nokia_BTS"."managedObject_distName_parent" = "nokia_BCF"."managedObject_distName"
  INNER JOIN public."nokia_BSC"
  ON
	"nokia_BCF"."managedObject_distName_parent" = "nokia_BSC"."managedObject_distName"

  LEFT JOIN "nokia_MAL"
  ON
	"nokia_BTS"."usedMobileAllocation" = "nokia_MAL"."managedObject_MAL" AND --info contenu dans BTS du numéro de MAL
	"nokia_BSC"."managedObject_distName" = "nokia_MAL"."managedObject_distName_parent" --Trouve le on MAL sur le bon BSC
  LEFT JOIN "nokia_MAL_frequency"
  ON
	"nokia_MAL"."managedObject_distName" = "nokia_MAL_frequency"."managedObject_distName" 
  LEFT JOIN tmp_nokia2g_bcch
  ON
	"nokia_BTS"."managedObject_distName" = tmp_nokia2g_bcch."BTS_managedObject_distName"
  LEFT JOIN tmp_nokia2g_trxinitialfreqs
  ON
	"nokia_BTS"."managedObject_distName" = tmp_nokia2g_trxinitialfreqs."BTS_managedObject_distName"

  LEFT JOIN tmp_nokia2g_nb_trx
  ON
	"nokia_BTS"."managedObject_distName" = tmp_nokia2g_nb_trx."BTS_managedObject_distName"

GROUP BY
  "nokia_BSC"."managedObject_distName",
  "nokia_BSC"."managedObject_BSC",
  "nokia_BSC".name,
  "nokia_BCF"."managedObject_distName",
  "nokia_BCF".name,
  "nokia_BCF"."siteTemplateDescription",
  "nokia_BCF"."SBTSId",
  "nokia_BTS"."managedObject_distName", 
  "nokia_BTS"."managedObject_BTS", 
  "nokia_BTS".name,
  right("nokia_BTS".name, 1),
  "nokia_BTS"."adminState", --1:ONLINE / 3:OFFLINE
  "nokia_BTS"."frequencyBandInUse", --0:GSM / 1:DCS
  "locationAreaIdMNC",
  "locationAreaIdMCC",
  "locationAreaIdLAC",
  rac,
  "cellId",
  "bsIdentityCodeNCC",
  "bsIdentityCodeBCC",
  tmp_nokia2g_bcch.bcch,
  tmp_nokia2g_nb_trx.nb_trx,
  "nokia_BTS"."hoppingMode",
  tmp_nokia2g_trxinitialfreqs."Freq_List",
  "nokia_BTS"."usedMobileAllocation"


ORDER BY
  "nokia_BTS".name
  --p_noname::int
 ;
