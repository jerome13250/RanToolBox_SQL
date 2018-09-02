--compte le nombre de TRX pour exclure la ma_liste des cellules qui n'ont qu'un seul trx:
DROP TABLE IF EXISTS tmp_nokia2g_nb_trx;
CREATE TEMP TABLE tmp_nokia2g_nb_trx AS
SELECT 
  "nokia_TRX"."managedObject_distName_parent" AS "BTS_managedObject_distName", 
  COUNT("nokia_TRX"."managedObject_TRX") AS nb_trx
FROM 
  public."nokia_TRX"
GROUP BY
  "nokia_TRX"."managedObject_distName_parent";

-- Creation de la table de toutes les fréquences 2G 1800 utilisées par cellule nokia:
DROP TABLE IF EXISTS t_checkLte1800Bandwith_01_freqconfig2g;
CREATE TABLE t_checkLte1800Bandwith_01_freqconfig2g AS

--Ajout des fréquences de MA Liste si Hopping
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
  "nokia_BTS"."adminState" AS "BTS_adminState", --1:ONLINE / 3:OFFLINE
  "nokia_BTS"."frequencyBandInUse", --0:GSM / 1:DCS
  CASE "nokia_BTS"."hoppingMode"
	WHEN '0' THEN 'Non-hopping'::text
	WHEN '1' THEN 'Baseband hopping'::text
	WHEN '2' THEN 'Radio Frequency hopping'::text
	ELSE 'ERROR'::text END AS "hoppingMode",
   p_noname::int AS freq
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
  LEFT JOIN tmp_nokia2g_nb_trx
  ON
	"nokia_BTS"."managedObject_distName" = tmp_nokia2g_nb_trx."BTS_managedObject_distName"
  WHERE
	"nokia_BTS"."frequencyBandInUse" = '1' AND --On se restreint aux cellules 1800
	"nokia_BTS"."hoppingMode" = '2' AND --Obligé de supprimer les cellules qui n'utilisent pas de Hopping car la MA Liste est renseignée quand même
	tmp_nokia2g_nb_trx.nb_trx > 1 --On ne prend pas en compte la ma sur les cellules qui ont un seul TRX

UNION --A noter que UNION par défault détruit tous les doublons (=UNION DISTINCT, sinon il faut utiliser UNION ALL)

--Ajout des BCCH et fréquences No hopping et baseband hopping:
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
  "nokia_BTS"."adminState" AS "BTS_adminState", --1:ONLINE / 3:OFFLINE
  "nokia_BTS"."frequencyBandInUse", --0:GSM / 1:DCS
  CASE "nokia_BTS"."hoppingMode"
	WHEN '0' THEN 'Non-hopping'::text
	WHEN '1' THEN 'Baseband hopping'::text
	WHEN '2' THEN 'Radio Frequency hopping'::text
	ELSE 'ERROR'::text END AS "hoppingMode",
  "nokia_TRX"."initialFrequency"::int AS freq
 
FROM 
  public."nokia_BTS" INNER JOIN "nokia_BCF"
  ON
	"nokia_BTS"."managedObject_distName_parent" = "nokia_BCF"."managedObject_distName"
  INNER JOIN public."nokia_BSC"
  ON
	"nokia_BCF"."managedObject_distName_parent" = "nokia_BSC"."managedObject_distName"
  LEFT JOIN "nokia_TRX"
  ON
	"nokia_BTS"."managedObject_distName" = "nokia_TRX"."managedObject_distName_parent"
WHERE
--  "nokia_TRX"."preferredBcchMark" = '1' --si on veut juste le bcch, si on supprime la condition on a les freqs de tous les TRXs
	"nokia_BTS"."frequencyBandInUse" = '1' --On se restreint aux cellules 1800, c'est plus simple pour les requetes suivantes
ORDER BY
  "BTS_name",
  freq
  ;


--Classement des SBTSid en fonction des frequences éligibles au 20/15 ou 10 MHz pour le LTE1800
DROP TABLE IF EXISTS t_checkLte1800Bandwith_02_sbtsconfigpossible;
CREATE TABLE t_checkLte1800Bandwith_02_sbtsconfigpossible AS

SELECT DISTINCT
  "SBTSId",
  string_agg(freq::text,'-'::text ORDER BY freq::int) AS freq_list,
  MIN( --MIN va prendre la config dans l'ordre la plus contraignante car c'est cette contrainte qui est à prendre en compte:
	  CASE
		WHEN ( freq > 535 AND freq < 585 ) THEN '0-PDF 2G incompatible !!!'::text
		WHEN ( freq > 524 AND freq < 598 ) THEN '1-L1800 10MHz'::text
		WHEN ( freq > 516 AND freq < 606 ) THEN '2-L1800 15MHz'::text
		WHEN ( freq > 515 AND freq < 607 ) THEN '3-L1800 20MHz + feat. 2G RG302087 + feat. 4G LTE786'::text
		ELSE '4-L1800 20MHz + feat. 2G RG302087'::text --Config optimale du DCS1800
	   END 
   ) AS "LTE1800_config_possible"
FROM 
  public.t_checkLte1800Bandwith_01_freqconfig2g
GROUP BY
  "SBTSId"
ORDER BY
  "SBTSId"
  ;


--Permet de lister les SBTS qui ont des cellules ou des TRXs allumés:
DROP TABLE IF EXISTS t_checkLte1800Bandwith_03_listcellsTrxNotOffline;
CREATE TABLE t_checkLte1800Bandwith_03_listcellsTrxNotOffline AS

SELECT 
  "nokia_BCF".name,
  "nokia_BCF"."SBTSId",
  "nokia_BTS"."adminState" AS "BTS_adminState", 
  "nokia_TRX"."adminState" AS "TRX_adminState"
FROM 
  public."nokia_TRX" INNER JOIN public."nokia_BTS"
  ON
	"nokia_TRX"."managedObject_distName_parent" = "nokia_BTS"."managedObject_distName"
  INNER JOIN public."nokia_BCF"
  ON
	"nokia_BTS"."managedObject_distName_parent" = "nokia_BCF"."managedObject_distName"
WHERE 
  "nokia_BTS"."frequencyBandInUse" = '1' AND--trie sur les 1800
  (
    --"nokia_BCF"."adminState" != '3' 
    "nokia_BTS"."adminState" != '3' 
    --OR "nokia_TRX"."adminState" != '3'	--Permet de lister les sites qui ont des cellules ou des TRXs allumés
  )
;

--On update sbtsconfigpossible avec les configs OffLine:
UPDATE t_checklte1800bandwith_02_sbtsconfigpossible
  SET "LTE1800_config_possible" = '5-L1800 20MHz / Cells+TRX Offline'::text

WHERE
  "SBTSId" NOT IN --Tous ceux qui ne sont pas dans la table NotOffline sont donc correctement Offline
  (
	SELECT DISTINCT  "SBTSId" FROM public.t_checklte1800bandwith_03_listcellstrxNotoffline
  )
 ;

--Requete finale :
DROP TABLE IF EXISTS "t_checkLte1800Bandwith_04_resultat";
CREATE TABLE "t_checkLte1800Bandwith_04_resultat" AS

--recherche des cellules à passer 15 MHz:
SELECT 
  t_topologie4g_nokia."managedObject_SBTS", 
  t_topologie4g_nokia.name, 
  t_topologie4g_nokia."sbtsDescription", 
  t_topologie4g_nokia."sbtsName", 
  t_topologie4g_nokia."managedObject_distName", 
  t_topologie4g_nokia."managedObject_LNCEL", 
  t_topologie4g_nokia."LNCEL_name", 
  t_topologie4g_nokia."earfcnDL", 
  t_topologie4g_nokia."eutraCelId", 
  t_topologie4g_nokia."dlChBw", 
  t_topologie4g_nokia."administrativeState", 
  t_topologie4g_nokia."operationalState", 
  freq_list,
  "LTE1800_config_possible"
FROM 
  public.t_topologie4g_nokia INNER JOIN public.t_checkLte1800Bandwith_02_sbtsconfigpossible
  ON 
  t_topologie4g_nokia."managedObject_SBTS" = t_checkLte1800Bandwith_02_sbtsconfigpossible."SBTSId"
WHERE
  "earfcnDL" = '1300'

ORDER BY "LNCEL_name"

  ;


