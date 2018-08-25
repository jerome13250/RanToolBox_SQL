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



-- Creation du mapping LCELW et ANTL
DROP TABLE IF EXISTS t_nokia_lcelw_antl;
CREATE TABLE t_nokia_lcelw_antl AS

SELECT
  "nokia_LCELW"."managedObject_distName" AS "LCELW_managedObject_distName", 
  "nokia_LCELW"."managedObject_LCELW", 
  "nokia_LCELW_resourceList"."LCELW_resourceList", 
  "nokia_LCELW_resourceList"."antlId", 
  "nokia_LCELW_resourceList"."txRxUsage",  
  "nokia_ANTL"."ulDelay", 
  "nokia_ANTL"."antId", 
  "nokia_ANTL"."antennaConnector", 
  "nokia_ANTL".bearing, 
  "nokia_ANTL"."cwaThreshold", 
  "nokia_ANTL"."dcVoltage", 
  "nokia_ANTL".defaults_name, 
  "nokia_ANTL"."feederLoss", 
  "nokia_ANTL"."frRef", 
  "nokia_ANTL"."hdlcCommunicationAllowed", 
  "nokia_ANTL"."lineLoss", 
  "nokia_ANTL"."rModId"
FROM 
  public."nokia_LCELW" INNER JOIN public."nokia_LCELW_resourceList"
  ON
     "nokia_LCELW"."managedObject_distName" = "nokia_LCELW_resourceList"."managedObject_distName"
  INNER JOIN public."nokia_BTSSCW"
  ON
     "nokia_LCELW_resourceList"."managedObject_distName_parent" = "nokia_BTSSCW"."managedObject_distName"
  INNER JOIN public."nokia_ANTL"
  ON
     "nokia_LCELW_resourceList"."antlId" = "nokia_ANTL"."managedObject_ANTL" AND
     "nokia_BTSSCW"."managedObject_distName_parent" = "nokia_ANTL"."managedObject_distName_parent"
ORDER BY 
  "nokia_LCELW"."managedObject_distName";

-- Creation du mapping LCELW et antlid1 antlid2
DROP TABLE IF EXISTS t_nokia_lcelw_crosstab_antlid;
CREATE TABLE t_nokia_lcelw_crosstab_antlid AS

SELECT * FROM crosstab(
   $$
	SELECT "LCELW_managedObject_distName", 
		
		row_number() OVER (PARTITION BY "LCELW_managedObject_distName" ORDER BY "antlId" ASC NULLS LAST) AS rn,
		"antlId"
		--"feederLoss"
	FROM   t_nokia_lcelw_antl
   $$
  , 'VALUES (1),(2)' --Liste les valeurs possibles de row_number
   ) AS t ("LCELW_managedObject_distName" text, "antlId1" text, "antlId2" text);


-- Creation du mapping LCELW et feederLoss1 feederLoss2
DROP TABLE IF EXISTS t_nokia_lcelw_crosstab_feederLoss;
CREATE TABLE t_nokia_lcelw_crosstab_feederLoss AS

SELECT * FROM crosstab(
   $$
	SELECT "LCELW_managedObject_distName", 
		
		row_number() OVER (PARTITION BY "LCELW_managedObject_distName" ORDER BY "antlId" ASC NULLS LAST) AS rn,
		"feederLoss"
	FROM   t_nokia_lcelw_antl
   $$
  , 'VALUES (1),(2)' --Liste les valeurs possibles de row_number
   ) AS t ("LCELW_managedObject_distName" text, "feederLoss1" text, "feederLoss2" text);



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

--Crée une table liant LCELW et type de board associé : ON UTILISE LA TABLE t_nokia_list_hardware qui recense tout le matériel nokia
--1ere partie, liste des cartes 2100:
DROP TABLE IF EXISTS t_nokia_lcelw_board;
CREATE TABLE t_nokia_lcelw_board AS
SELECT
  "nokia_LCELW"."managedObject_LCELW", 
  "nokia_LCELW"."managedObject_distName", 
  "nokia_SBTS"."managedObject_distName" AS "SBTS_managedObject_distName", 
  t_nokia_list_hardware."inventoryUnitType", 
  COUNT(t_nokia_list_hardware."inventoryUnitType") AS "inventoryUnitType_count",
  t_nokia_list_hardware.board_info,
  'U2100'::text AS bande
FROM 
  public."nokia_LCELW" INNER JOIN public."nokia_BTSSCW" 
  ON
    "nokia_LCELW"."managedObject_distName_parent" = "nokia_BTSSCW"."managedObject_distName" --liaison LCELW vers BTSSCW
  INNER JOIN public."nokia_SBTS"
  ON
    "nokia_BTSSCW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName" --liaison BTSSCW et HW (clé=SBTS)
  INNER JOIN public.t_nokia_list_hardware
  ON
    "nokia_SBTS"."managedObject_SBTS" = t_nokia_list_hardware."managedObject_SBTS"
WHERE 
  t_nokia_list_hardware.board_info LIKE '%2100%'
GROUP BY
  "nokia_LCELW"."managedObject_LCELW", 
  "nokia_LCELW"."managedObject_distName", 
  "nokia_SBTS"."managedObject_distName", 
  t_nokia_list_hardware."inventoryUnitType", 
   t_nokia_list_hardware.board_info

UNION 

--2eme partie, liste des cartes 900:
SELECT
  "nokia_LCELW"."managedObject_LCELW", 
  "nokia_LCELW"."managedObject_distName", 
  "nokia_SBTS"."managedObject_distName" AS "SBTS_managedObject_distName", 
  t_nokia_list_hardware."inventoryUnitType", 
  COUNT(t_nokia_list_hardware."inventoryUnitType") AS "inventoryUnitType_count",
  t_nokia_list_hardware.board_info,
  'U900'::text AS bande
FROM 
  public."nokia_LCELW" INNER JOIN public."nokia_BTSSCW" 
  ON
    "nokia_LCELW"."managedObject_distName_parent" = "nokia_BTSSCW"."managedObject_distName" --liaison LCELW vers BTSSCW
  INNER JOIN public."nokia_SBTS"
  ON
    "nokia_BTSSCW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName" --liaison BTSSCW et HW (clé=SBTS)
  INNER JOIN public.t_nokia_list_hardware
  ON
    "nokia_SBTS"."managedObject_SBTS" = t_nokia_list_hardware."managedObject_SBTS"
WHERE 
  t_nokia_list_hardware.board_info LIKE '%900%'
GROUP BY
  "nokia_LCELW"."managedObject_LCELW", 
  "nokia_LCELW"."managedObject_distName", 
  "nokia_SBTS"."managedObject_distName", 
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
  public."nokia_WCEL" LEFT JOIN public."nokia_LCELW"
  ON
	"nokia_WCEL"."managedObject_WCEL" = "nokia_LCELW"."managedObject_LCELW"
WHERE
  "UARFCN"::int > 10000 AND --frequences U2100
  NOT ("nokia_WCEL"."UARFCN" = '10712' AND "nokia_LCELW"."maxCarrierPower"='0') --On exclue les FDD7 en cours de création avec puissance=0
  
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
DROP TABLE IF EXISTS t_nokia_power_final;
CREATE TABLE t_nokia_power_final AS
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
  t_nokia_lcelw_board."inventoryUnitType",
  t_nokia_lcelw_board."inventoryUnitType_count",
  t_nokia_lcelw_board.board_info,
  CASE WHEN t_nokia_lcelw_board.bande='U900' THEN "t_nokiapower_bts_trxrfpower"."BTS_name" ELSE NULL END AS "2G_BTS_name", --nom de la cellule gsm
  CASE WHEN t_nokia_lcelw_board.bande='U900' THEN "t_nokiapower_bts_trxrfpower".trx_count ELSE NULL END AS "2G_trx_count",
  CASE WHEN t_nokia_lcelw_board.bande='U900' THEN "t_nokiapower_bts_trxrfpower"."trxRfPower_sum_mW" ELSE NULL END AS "2G_trxRfPower_sum_mW",

  --definition des power limitations cause 2G:
  CASE 
	WHEN t_nokia_lcelw_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"inventoryUnitType"='FXDB' AND 
		"inventoryUnitType_count" = 1
	THEN floor(100*log_nofail(73000-"trxRfPower_sum_mW"))

	WHEN t_nokia_lcelw_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"btsProfile" IN ('LWG_2fsm53_1','LWG_2fsm53_2','LWG_2fsm53_3','LWG_2fsm53_5', 'LWG_2fsm102', 'WG52_1', 'LWG_2fsm111_1') AND
		"inventoryUnitType"='FXDB' AND 
		"inventoryUnitType_count" = 2
	THEN 490::float --dans ce cas pas de limitation car tous les TRXs sont sur l'autre voix d'emission

	WHEN t_nokia_lcelw_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"btsProfile" NOT IN ('LWG_2fsm53_1','LWG_2fsm53_2','LWG_2fsm53_3','LWG_2fsm53_5', 'LWG_2fsm102', 'WG52_1', 'LWG_2fsm111_1') AND
		"inventoryUnitType"='FXDB' AND 
		"inventoryUnitType_count" = 2
	THEN floor(100*log_nofail(73000-"trxRfPower_sum_mW"/trx_count*(floor(trx_count/2)+mod(trx_count,2))))
		

	WHEN t_nokia_lcelw_board.bande='U900' AND --on est bien sur du U900
		"t_nokiapower_bts_trxrfpower"."BTS_name" IS NOT NULL AND --On a de la 2G Coloc
		"inventoryUnitType"='FHDB'
	THEN floor(100*log_nofail(55000-"trxRfPower_sum_mW"/trx_count*(floor(trx_count/2)+mod(trx_count,2))))

	
   ELSE NULL END AS "power3G_limitation_cause2G",




  t_nokia_lcelw_board.bande,
  t_topologie3g_nokia."WCEL_CableLoss",
  t_nokia_lcelw_crosstab_antlid."antlId1" AS "LCELW_antlId1_info",
  t_nokia_lcelw_crosstab_feederloss."feederLoss1" AS "LCELW_feederLoss1",
  t_nokia_lcelw_crosstab_antlid."antlId2" AS "LCELW_antlId2_info",
  t_nokia_lcelw_crosstab_feederloss."feederLoss2" AS "LCELW_feederLoss2",
  t_topologie3g_nokia."WCEL_PtxPrimaryCPICH", 
  t_topologie3g_nokia."WCEL_PtxCellMax", 
  t_topologie3g_nokia."WCEL_MaxDLPowerCapability",  --ne sert a rien, copie juste LCELW_maxCarrierPower 
  t_topologie3g_nokia."LCELW_maxCarrierPower",
  "nokia_WCEL"."PtxDLabsMax",
  "nokia_WCEL"."PtxHighHSDPAPwr",
  "nokia_WCEL"."PtxMaxHSDPA",
  "nokia_WCEL"."PtxPSstreamAbsMax",
  "nokia_WCEL"."PtxTarget",
  NULL::text AS "PtxTargetHSDPA", --parametre obsolete disparu
  "nokia_WCEL"."PtxTargetPSMax",
  "nokia_WCEL"."PtxTargetPSMin"


  --CALCUL DES VALEURS EN FONCTION DE PERTE P2:
  --castinteger(t_nokiapower_lcid_pertep2."PERTES_P2") + 4 AS "CALCUL_WCEL_CableLoss", --perte p2 decidB + 0.4 dB perte bretelle
  --castinteger(t_nokiapower_lcid_pertep2."PERTES_P2") + 4 AS "CALCUL_LCELW_feederLoss1",
  --castinteger(t_nokiapower_lcid_pertep2."PERTES_P2") + 4 AS "CALCUL_LCELW_feederLoss2"
  
FROM 
  public.t_topologie3g_nokia LEFT JOIN t_nokiapower_freqconfig
  ON
    t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokiapower_freqconfig."managedObject_distName_parent" AND
    t_topologie3g_nokia."SectorID" = t_nokiapower_freqconfig."SectorID" AND
    t_topologie3g_nokia."BANDE" = t_nokiapower_freqconfig.bande
  LEFT JOIN t_nokia_lcelw_board
  ON
    t_topologie3g_nokia."managedObject_WCEL" = t_nokia_lcelw_board."managedObject_LCELW" AND
    t_topologie3g_nokia."BANDE" = t_nokia_lcelw_board.bande
  LEFT JOIN t_nokia_lcelw_crosstab_antlid
  ON
    t_topologie3g_nokia."LCELW_managedObject_distName" = t_nokia_lcelw_crosstab_antlid."LCELW_managedObject_distName"
  LEFT JOIN t_nokia_lcelw_crosstab_feederloss
  ON
    t_topologie3g_nokia."LCELW_managedObject_distName" = t_nokia_lcelw_crosstab_feederloss."LCELW_managedObject_distName" 
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
