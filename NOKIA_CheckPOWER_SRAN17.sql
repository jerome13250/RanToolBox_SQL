CREATE OR REPLACE FUNCTION log_nofail(float) RETURNS FLOAT AS 
$$
DECLARE x FLOAT;
BEGIN
    x = log($1);
    RETURN x;
EXCEPTION WHEN others THEN
    RETURN 'NaN';
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;

--Mise en forme du champ "lCelwDN" car il manque le début de la clé : 'PLMN-PLMN/'
UPDATE public."nokia_WNCEL"
  SET "lCelwDN" = 'PLMN-PLMN/' || "lCelwDN"
WHERE
   "lCelwDN" NOT LIKE 'PLMN-PLMN%'
;

--Mise en forme du champ "antlDN" car il manque le début de la clé : 'PLMN-PLMN/'
UPDATE public."nokia_CHANNEL"
  SET "antlDN" = 'PLMN-PLMN/' || "antlDN"
WHERE
   "antlDN" NOT LIKE 'PLMN-PLMN%'
;

-- Creation du mapping WNCEL et ANTL :
DROP TABLE IF EXISTS t_nokia_wncel_antl;
CREATE TABLE t_nokia_wncel_antl AS

SELECT DISTINCT
  "nokia_WNCEL"."managedObject_version", 
  "nokia_WNCEL"."managedObject_distName" AS "WNCEL_managedObject_distName",
  "nokia_WNCEL"."managedObject_WNCEL", 
  "nokia_CHANNEL"."antlDN", 
  "nokia_ANTL"."totalLoss"
FROM 
  public."nokia_LCELW" INNER JOIN public."nokia_CHANNELGROUP" 
  ON
	"nokia_LCELW"."managedObject_distName" = "nokia_CHANNELGROUP"."managedObject_distName_parent"
  INNER JOIN public."nokia_CHANNEL"
  ON
	"nokia_CHANNEL"."managedObject_distName_parent" = "nokia_CHANNELGROUP"."managedObject_distName"
  INNER JOIN public."nokia_WNCEL"
  ON
	"nokia_WNCEL"."lCelwDN" = "nokia_LCELW"."managedObject_distName"
  INNER JOIN public."nokia_ANTL"
  ON
	"nokia_CHANNEL"."antlDN" = "nokia_ANTL"."managedObject_distName"
ORDER BY
  "nokia_WNCEL"."managedObject_distName" ASC, 
  "nokia_CHANNEL"."antlDN" ASC;

-- Creation du mapping WNCEL et antlDN1 et antlDN2
DROP TABLE IF EXISTS t_nokia_wncel_crosstab_antldn;
CREATE TABLE t_nokia_wncel_crosstab_antldn AS

SELECT * FROM crosstab(
   $$
	SELECT  "WNCEL_managedObject_distName",
		"managedObject_WNCEL",	
		row_number() OVER (PARTITION BY "WNCEL_managedObject_distName" ORDER BY "antlDN" ASC NULLS LAST) AS rn,
		"antlDN"
		--"totalLoss"
	FROM   t_nokia_wncel_antl
   $$
  , 'VALUES (1),(2)' --Liste les valeurs possibles de row_number
   ) AS t ("WNCEL_managedObject_distName" text, "managedObject_WNCEL" text, "antlId1" text, "antlId2" text);

-- Creation du mapping LCELW et totalLoss1 totalLoss2
DROP TABLE IF EXISTS t_nokia_wncel_crosstab_totalLoss;
CREATE TABLE t_nokia_wncel_crosstab_totalLoss AS

SELECT * FROM crosstab(
   $$
	SELECT  "WNCEL_managedObject_distName",
		"managedObject_WNCEL",
		row_number() OVER (PARTITION BY "WNCEL_managedObject_distName" ORDER BY "antlDN" ASC NULLS LAST) AS rn,
		"totalLoss"
	FROM   t_nokia_wncel_antl
   $$
  , 'VALUES (1),(2)' --Liste les valeurs possibles de row_number
   ) AS t ("WNCEL_managedObject_distName" text, "managedObject_WNCEL" text, "totalLoss1" text, "totalLoss2" text);

-- Creation de la liste des  mapping lcid et pertep2
DROP TABLE IF EXISTS t_nokiapower_lcid_pertep2;
CREATE TABLE t_nokiapower_lcid_pertep2 AS

SELECT 
  t_noria_topo_3g."NOM", 
  t_noria_topo_3g."IDRESEAUCELLULE", 
  t_noria_topo_3g."ETAT_DEPL", 
  t_noria_topo_3g."ETAT_FONCT", 
  t_noria_topo_3g."GN", 
  t_noria_topo_3g."X", 
  t_noria_topo_3g."Y", 
  t_noria_topo_3g."PERTES_P2_UMTS2200_MAIN" AS "PERTES_P2"
FROM 
  public.t_noria_topo_3g
WHERE
  "BANDE" = 'UMTS 2200 MHz' AND
  "PERTES_P2_UMTS2200_MAIN" IS NOT NULL AND
  "PERTES_P2_UMTS2200_MAIN" != '' AND
  "PERTES_P2_UMTS2200_MAIN" != '0'

UNION

SELECT 
  t_noria_topo_3g."NOM", 
  t_noria_topo_3g."IDRESEAUCELLULE", 
  t_noria_topo_3g."ETAT_DEPL", 
  t_noria_topo_3g."ETAT_FONCT", 
  t_noria_topo_3g."GN", 
  t_noria_topo_3g."X", 
  t_noria_topo_3g."Y", 
  t_noria_topo_3g."PERTES_P2_UMTS900_MAIN"
FROM 
  public.t_noria_topo_3g
WHERE
  "BANDE" = 'UMTS 900 MHz' AND
  "PERTES_P2_UMTS900_MAIN" IS NOT NULL AND
  "PERTES_P2_UMTS900_MAIN" != '' AND
  "PERTES_P2_UMTS900_MAIN" != '0'
;

--Crée une table liant WNCEL et type de board associé : ON UTILISE LA TABLE t_nokia_list_hardware qui recense tout le matériel nokia
--1ere partie, liste des cartes 2100:
DROP TABLE IF EXISTS t_nokia_wncel_board;
CREATE TABLE t_nokia_wncel_board AS
SELECT
  "nokia_WNCEL"."managedObject_WNCEL", 
  "nokia_WNCEL"."managedObject_distName", 
  "nokia_MRBTS"."managedObject_distName" AS "MRBTS_managedObject_distName", 
  t_nokia_list_hardware."inventoryUnitType", 
  COUNT(t_nokia_list_hardware."inventoryUnitType") AS "inventoryUnitType_count",
  t_nokia_list_hardware.board_info,
  'U2100'::text AS bande
FROM 
  public."nokia_WNCEL" INNER JOIN public."nokia_WNBTS" 
  ON
    "nokia_WNCEL"."managedObject_distName_parent" = "nokia_WNBTS"."managedObject_distName" --liaison WNCEL vers WNBTS
  INNER JOIN public."nokia_MRBTS"
  ON
    "nokia_WNBTS"."managedObject_distName_parent" = "nokia_MRBTS"."managedObject_distName" --liaison WNBTS et HW (clé=MRBTS)
  INNER JOIN public.t_nokia_list_hardware
  ON
    "nokia_MRBTS"."managedObject_MRBTS" = t_nokia_list_hardware."managedObject_SBTS" --la table hardware garde le vieux nom SBTS...
WHERE 
  t_nokia_list_hardware.board_info LIKE '%2100%'
GROUP BY
  "nokia_WNCEL"."managedObject_WNCEL", 
  "nokia_WNCEL"."managedObject_distName", 
  "nokia_MRBTS"."managedObject_distName", 
  t_nokia_list_hardware."inventoryUnitType", 
   t_nokia_list_hardware.board_info

UNION 

--2eme partie, liste des cartes 900:
SELECT
  "nokia_WNCEL"."managedObject_WNCEL", 
  "nokia_WNCEL"."managedObject_distName", 
  "nokia_MRBTS"."managedObject_distName" AS "MRBTS_managedObject_distName", 
  t_nokia_list_hardware."inventoryUnitType", 
  COUNT(t_nokia_list_hardware."inventoryUnitType") AS "inventoryUnitType_count",
  t_nokia_list_hardware.board_info,
  'U900'::text AS bande
FROM 
  public."nokia_WNCEL" INNER JOIN public."nokia_WNBTS" 
  ON
    "nokia_WNCEL"."managedObject_distName_parent" = "nokia_WNBTS"."managedObject_distName" --liaison WNCEL vers WNBTS
  INNER JOIN public."nokia_MRBTS"
  ON
    "nokia_WNBTS"."managedObject_distName_parent" = "nokia_MRBTS"."managedObject_distName" --liaison WNBTS et HW (clé=MRBTS)
  INNER JOIN public.t_nokia_list_hardware
  ON
    "nokia_MRBTS"."managedObject_MRBTS" = t_nokia_list_hardware."managedObject_SBTS" --la table hardware garde le vieux nom SBTS...
WHERE 
  t_nokia_list_hardware.board_info LIKE '%900%'
GROUP BY
  "nokia_WNCEL"."managedObject_WNCEL", 
  "nokia_WNCEL"."managedObject_distName", 
  "nokia_MRBTS"."managedObject_distName", 
  t_nokia_list_hardware."inventoryUnitType", 
   t_nokia_list_hardware.board_info
;

--Donne les freq_config u2100 sur le terrain:
DROP TABLE IF EXISTS t_nokiapower_freqconfig;
CREATE TABLE t_nokiapower_freqconfig AS
SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL"."SectorID",
  'U2100'::text AS bande, 
  string_agg("nokia_WCEL"."UARFCN", '-' ORDER BY "nokia_WCEL"."UARFCN") AS freq_config
FROM 
  public."nokia_WCEL" LEFT JOIN public."nokia_WNCEL"
  ON
	"nokia_WCEL"."managedObject_WCEL" = "nokia_WNCEL"."managedObject_WNCEL"
WHERE
  "UARFCN"::int > 10000 AND --frequences U2100
  NOT ("nokia_WCEL"."UARFCN" = '10712' AND "nokia_WNCEL"."maxCarrierPower"='0') --On exclue les FDD7 en cours de création avec puissance=0
  
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL"."SectorID"

  
UNION --Liste les freq_config U900:

SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID",
  'U900'::text AS bande, 
  string_agg("nokia_WCEL"."UARFCN", '-' ORDER BY "nokia_WCEL"."UARFCN") AS freq_config
  --COUNT("nokia_WCEL"."UARFCN")
FROM 
  public."nokia_WCEL"
WHERE
  "UARFCN"::int < 10000
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID";



-- Creation du rapport de puissance 2G G900:
DROP TABLE IF EXISTS t_nokiapower_bts_trxrfpower;
CREATE TABLE t_nokiapower_bts_trxrfpower AS

SELECT 
  t_topologie2g_trx_nokia."BCF_managedObject_distName", 
  t_topologie2g_trx_nokia."BCF_name", 
  t_topologie2g_trx_nokia."BCF_siteTemplateDescription", 
  t_topologie2g_trx_nokia."SBTSId",
  t_topologie2g_trx_nokia."BTS_managedObject_distName", 
  t_topologie2g_trx_nokia."managedObject_BTS", 
  t_topologie2g_trx_nokia."BTS_name", 
  t_topologie2g_trx_nokia.sectorid, 
  t_topologie2g_trx_nokia."BTS_adminState", 
  t_topologie2g_trx_nokia."frequencyBandInUse", 
  count(t_topologie2g_trx_nokia."managedObject_TRX") AS trx_count, 
  SUM(t_topologie2g_trx_nokia."trxRfPower"::int) AS "trxRfPower_sum_mW"
FROM 
  public.t_topologie2g_trx_nokia
WHERE
  t_topologie2g_trx_nokia."frequencyBandInUse" = '0' --Filtre sur gsm900
GROUP BY
  t_topologie2g_trx_nokia."BCF_managedObject_distName", 
  t_topologie2g_trx_nokia."BCF_name", 
  t_topologie2g_trx_nokia."BCF_siteTemplateDescription",
  t_topologie2g_trx_nokia."SBTSId", 
  t_topologie2g_trx_nokia."BTS_managedObject_distName", 
  t_topologie2g_trx_nokia."managedObject_BTS", 
  t_topologie2g_trx_nokia."BTS_name", 
  t_topologie2g_trx_nokia.sectorid, 
  t_topologie2g_trx_nokia."BTS_adminState", 
  t_topologie2g_trx_nokia."frequencyBandInUse"
ORDER BY
  t_topologie2g_trx_nokia."BTS_name";

--Requete principale
--DROP TABLE IF EXISTS t_nokia_power_final;
--CREATE TABLE t_nokia_power_final AS
SELECT DISTINCT
  t_topologie3g_nokia."RNC_managedObject_distName", 
  t_topologie3g_nokia."RNCName", 
  t_topologie3g_nokia."RNC_id", 
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia."btsProfile",
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID", 
  t_topologie3g_nokia."AdminCellState", 
  t_topologie3g_nokia."WCelState",
  t_topologie3g_nokia."SectorID",

  t_topologie3g_nokia."UARFCN", 
  t_topologie3g_nokia."BANDE",
  t_topologie3g_nokia."LCELW_vamEnabled",
  t_topologie3g_nokia."WCEL_MHA",
  replace(t_nokiapower_lcid_pertep2."PERTES_P2",'.',',') AS pertesP2Noria, --transforme les points en virgules
  t_nokiapower_freqconfig.freq_config AS freq_config,
  t_nokia_wncel_board."inventoryUnitType",
  t_nokia_wncel_board."inventoryUnitType_count",
  t_nokia_wncel_board.board_info,
  CASE WHEN t_nokia_wncel_board.bande='U900' THEN "t_nokiapower_bts_trxrfpower"."BTS_name" ELSE NULL END AS "2G_BTS_name", --nom de la cellule gsm
  CASE WHEN t_nokia_wncel_board.bande='U900' THEN "t_nokiapower_bts_trxrfpower".trx_count ELSE NULL END AS "2G_trx_count",
  CASE WHEN t_nokia_wncel_board.bande='U900' THEN "t_nokiapower_bts_trxrfpower"."trxRfPower_sum_mW" ELSE NULL END AS "2G_trxRfPower_sum_mW",

  --definition des power limitations cause 2G:
  CASE 
	WHEN t_nokia_wncel_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"inventoryUnitType"='FXDB' AND 
		"inventoryUnitType_count" = 1
	THEN floor(100*log_nofail(73000-"trxRfPower_sum_mW"))

	WHEN t_nokia_wncel_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"btsProfile" IN ('LWG_2fsm53_1','LWG_2fsm53_2','LWG_2fsm53_3','LWG_2fsm53_5', 'LWG_2fsm102', 'WG52_1','LWG_2fsm111_1','MRBTS_noProfile') AND
		"inventoryUnitType"='FXDB' AND 
		"inventoryUnitType_count" = 2
	THEN 490::float --dans ce cas pas de limitation car tous les TRXs sont sur l'autre voix d'emission

	WHEN t_nokia_wncel_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"btsProfile" NOT IN ('LWG_2fsm53_1','LWG_2fsm53_2','LWG_2fsm53_3','LWG_2fsm53_5', 'LWG_2fsm102', 'WG52_1', 'LWG_2fsm111_1','MRBTS_noProfile') AND
		"inventoryUnitType"='FXDB' AND 
		"inventoryUnitType_count" = 2
	THEN floor(100*log_nofail(73000-"trxRfPower_sum_mW"/trx_count*(floor(trx_count/2)+mod(trx_count,2))))
		

	WHEN t_nokia_wncel_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"inventoryUnitType"='FHDB'
	THEN floor(100*log_nofail(55000-"trxRfPower_sum_mW"/trx_count*(floor(trx_count/2)+mod(trx_count,2))))

	
   ELSE NULL END AS "power3G_limitation_cause2G",

  t_nokia_wncel_board.bande,
  t_topologie3g_nokia."WCEL_CableLoss",
  t_nokia_wncel_crosstab_antldn."antlId1" AS "WNCEL_antlId1_info",
  t_nokia_wncel_crosstab_totalLoss."totalLoss1" AS "WNCEL_totalLoss1",
  t_nokia_wncel_crosstab_antldn."antlId2" AS "WNCEL_antlId2_info",
  t_nokia_wncel_crosstab_totalLoss."totalLoss2" AS "WNCEL_totalLoss2",
  t_topologie3g_nokia."WCEL_PtxPrimaryCPICH", 
  t_topologie3g_nokia."WCEL_PtxCellMax", 
  t_topologie3g_nokia."WCEL_MaxDLPowerCapability",  --ne sert a rien, copie juste WNCEL_maxCarrierPower 
  t_topologie3g_nokia."LCELW_maxCarrierPower",
  "nokia_WCEL"."PtxDLabsMax",
  "nokia_WCEL"."PtxHighHSDPAPwr",
  "nokia_WCEL"."PtxMaxHSDPA",
  "nokia_WCEL"."PtxPSstreamAbsMax",
  "nokia_WCEL"."PtxTarget",
  "nokia_WCEL"."PtxTargetPSMax",
  "nokia_WCEL"."PtxTargetPSMin"
  
FROM 
  public.t_topologie3g_nokia LEFT JOIN t_nokiapower_freqconfig
  ON
    t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokiapower_freqconfig."managedObject_distName_parent" AND
    t_topologie3g_nokia."SectorID" = t_nokiapower_freqconfig."SectorID" AND
    t_topologie3g_nokia."BANDE" = t_nokiapower_freqconfig.bande
  INNER JOIN t_nokia_wncel_board --temporairement je mets un INNER JOIN pour limiter la requête au SRAN17
  ON
    t_topologie3g_nokia."managedObject_WCEL" = t_nokia_wncel_board."managedObject_WNCEL" AND
    t_topologie3g_nokia."BANDE" = t_nokia_wncel_board.bande
  LEFT JOIN t_nokia_wncel_crosstab_antldn
  ON
    t_topologie3g_nokia."managedObject_WCEL" = t_nokia_wncel_crosstab_antldn."managedObject_WNCEL"
  LEFT JOIN t_nokia_wncel_crosstab_totalLoss
  ON
    t_topologie3g_nokia."managedObject_WCEL" = t_nokia_wncel_crosstab_totalLoss."managedObject_WNCEL" 
  LEFT JOIN t_nokiapower_lcid_pertep2
  ON
    t_topologie3g_nokia."managedObject_WCEL" = t_nokiapower_lcid_pertep2."IDRESEAUCELLULE"
  LEFT JOIN "nokia_WCEL"
  ON
    t_topologie3g_nokia."WCEL_managedObject_distName" = "nokia_WCEL"."managedObject_distName"
  LEFT JOIN t_nokiapower_bts_trxrfpower
  ON
    t_topologie3g_nokia."SectorID" = t_nokiapower_bts_trxrfpower.sectorid AND --clé sur sectorid
    t_topologie3g_nokia."SBTSId" = t_nokiapower_bts_trxrfpower."SBTSId" --clé sur le SBTSId
WHERE 
  t_topologie3g_nokia."RNC_managedObject_distName" IS NOT NULL  

  --AND t_topologie3g_nokia.name LIKE '%VIALA%'
  
ORDER BY
  t_topologie3g_nokia.name ASC;
