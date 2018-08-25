--Creation  de la concatenation des uraid sur un seul champ:
DROP TABLE IF EXISTS t_temp_nokia_uraid;
CREATE TABLE t_temp_nokia_uraid AS
SELECT 
  "nokia_WCEL_URAId"."managedObject_distName", 
  string_agg("nokia_WCEL_URAId".p_noname,'_') AS "URAId"
FROM 
  public."nokia_WCEL_URAId"
GROUP BY
  "nokia_WCEL_URAId"."managedObject_distName";

DROP TABLE IF EXISTS t_topologie3g_nokia;
CREATE TABLE t_topologie3g_nokia AS

--première partie : format anciennes SBTS 
SELECT DISTINCT
  "nokia_RNC"."managedObject_distName" AS "RNC_managedObject_distName",
  "nokia_RNC"."RNCName",
  "nokia_RNC"."managedObject_RNC" AS "RNC_id",
  "nokia_WBTS"."WBTSName",
  "nokia_WBTS"."managedObject_distName" AS "WBTS_managedObject_distName",
  "nokia_WBTS"."BTSAdditionalInfo",
  "nokia_WBTS"."SBTSId",
  "nokia_SBTS"."managedObject_distName" AS "SBTS_managedObject_distName",
  "nokia_SBTS"."btsProfile",
  "nokia_SBTS"."sbtsDescription",
  "nokia_WCEL"."name",
  "nokia_WCEL"."managedObject_WCEL",
  "nokia_WCEL"."managedObject_distName" AS "WCEL_managedObject_distName",
  "nokia_WCEL".defaults_name AS netact_tpl, --template utilisé a l'omc pour creer les cellules
  "nokia_LCELW"."managedObject_distName" AS "LCELW_managedObject_distName", --utile pour eviter les doublons une fois que le mapping
  "nokia_WCEL"."CId",
  "nokia_WCEL"."UARFCN",
  CASE 	WHEN ("nokia_WCEL"."UARFCN"::integer > 10000) THEN 'U2100'::text
	ELSE 'U900'::text END 
	AS "BANDE",
  "nokia_WCEL"."LAC", 
  "nokia_WCEL"."RAC", 
  "nokia_WCEL"."SAC",
  "nokia_WCEL"."SectorID",
  --uraid est dans une sous table liste:
  t_temp_nokia_uraid."URAId",

  "nokia_WCEL"."PriScrCode",
  "nokia_WCEL"."WCELMCC", 
  "nokia_WCEL"."WCELMNC", 
  "nokia_WCEL"."AdminCellState", 
  (to_number("nokia_WCEL"."WCelState", '999999999999'))::integer::bit(12) AS "WCelState",
  "nokia_WCEL"."CellRange", 
  "nokia_WCEL"."CellSelQualMeas", 
  "nokia_WCEL"."QqualMin",
  "nokia_WCEL"."QrxlevMin",  
  "nokia_WCEL"."CellBarred", 
  "nokia_WCEL"."Cell_Reserved",

  --mapping LCG:
  "nokia_LCELGW_lCelwIdList"."managedObject_distName" AS "LCELGW_managedObject_distName",
  
  --mapping scheduler:
  "nokia_WCEL"."Tcell",
  CASE 
   	WHEN "nokia_WCEL"."Tcell" IN ('0','1','2','6','7','8') THEN '1'
	WHEN "nokia_WCEL"."Tcell" IN ('3','4','5','9') THEN '2'
	ELSE NULL END 
	AS "scheduler_mapping",
   
  --Liste des fmc mobilité:
  "nokia_WCEL"."SRBHSPAFmcsId",
  "nokia_WCEL"."SRBDCHFmcsId",
  "nokia_WCEL"."RTWithHSPAFmcsIdentifier",
  "nokia_WCEL"."RTWithHSDPAFmcsIdentifier",
  "nokia_WCEL"."RtFmcsIdentifier",
  "nokia_WCEL"."NrtFmcsIdentifier",
  "nokia_WCEL"."HSPAFmcsIdentifier",
  "nokia_WCEL"."HSDPAFmcsIdentifier",
  "nokia_WCEL"."DCellHSDPAFmcsId",
  "nokia_WCEL"."RTWithHSDPAFmciIdentifier",
  "nokia_WCEL"."RtFmciIdentifier",
  "nokia_WCEL"."NrtFmciIdentifier",
  "nokia_WCEL"."HSDPAFmciIdentifier",
  "nokia_WCEL"."RTWithHSDPAFmcgIdentifier",
  "nokia_WCEL"."RtFmcgIdentifier",
  "nokia_WCEL"."NrtFmcgIdentifier",
  "nokia_WCEL"."HSDPAFmcgIdentifier",
  "nokia_WCEL"."FMCLIdentifier",


  --Parametrage puissance:
  "nokia_WCEL"."MHA" AS "WCEL_MHA", 
  "nokia_WCEL"."CableLoss" AS "WCEL_CableLoss",
  "nokia_WCEL"."PtxPrimaryCPICH" AS "WCEL_PtxPrimaryCPICH", 
  "nokia_WCEL"."PtxCellMax" AS "WCEL_PtxCellMax",
  "nokia_WCEL"."MaxDLPowerCapability" AS "WCEL_MaxDLPowerCapability", --Value set by the system.
  "nokia_LCELW"."vamEnabled" AS "LCELW_vamEnabled",
  "nokia_LCELW"."maxCarrierPower" AS "LCELW_maxCarrierPower", 
  "nokia_LCELW"."mimoType" AS "LCELW_mimoType", 
  "nokia_LCELW"."rxBandwidth" AS "LCELW_rxBandwidth", 
  "nokia_LCELW"."txBandwidth" AS "LCELW_txBandwidth",
/*
  --Parametrage IDLE: 
  "nokia_WCEL"."Sintrasearch",
  "nokia_WCEL"."SintrasearchConn",
  "nokia_WCEL"."Sintersearch",
  "nokia_WCEL"."SintersearchConn",
  "nokia_WCEL"."Ssearch_RAT",
  "nokia_WCEL"."Ssearch_RATConn",
  "nokia_WCEL"."UEtxPowerMaxDPCH",
  "nokia_WCEL"."UEtxPowerMaxPRACH",
  "nokia_WCEL"."UEtxPowerMaxPRACHConn",
  "nokia_WCEL"."Treselection", 
  "nokia_WCEL"."TreselectionFACH", 
  "nokia_WCEL"."TreselectionPCH",

  --Parametrage Reselection LTE
  "nokia_WCEL"."LTECellReselection",
  "nokia_WCEL"."AbsPrioCellReselec",
  "nokia_WCEL"."Sprioritysearch1",
  "nokia_WCEL"."Sprioritysearch2",
  "nokia_WCEL"."Threshservlow",
*/
  --Données NORIA:
  t_noria_topo_3g."GN"

FROM 
  public."nokia_WCEL" LEFT JOIN public."nokia_WBTS"
	ON "nokia_WCEL"."managedObject_distName_parent" = "nokia_WBTS"."managedObject_distName"
  LEFT JOIN public."nokia_RNC"
	ON "nokia_WBTS"."managedObject_distName_parent" = "nokia_RNC"."managedObject_distName"
  LEFT JOIN t_temp_nokia_uraid
	ON "nokia_WCEL"."managedObject_distName" = t_temp_nokia_uraid."managedObject_distName"
  LEFT JOIN public."nokia_LCELW" 
	ON "nokia_WCEL"."managedObject_WCEL" = "nokia_LCELW"."managedObject_LCELW" --obligé de rajouter un test WHERE car il y a des lcid en double
  LEFT JOIN public.t_noria_topo_3g
	ON "nokia_WCEL"."managedObject_WCEL" = t_noria_topo_3g."IDRESEAUCELLULE" 
  LEFT JOIN public."nokia_LCELGW_lCelwIdList" 
	ON "nokia_WCEL"."managedObject_WCEL" = "nokia_LCELGW_lCelwIdList".p_noname --obligé de rajouter un test WHERE car il y a des lcid en double
  LEFT JOIN public."nokia_SBTS"
        ON "nokia_WBTS"."SBTSId" = "nokia_SBTS"."managedObject_SBTS"
WHERE
  ("nokia_LCELW"."managedObject_distName" LIKE 'PLMN-PLMN/SBTS-%' || "nokia_WBTS"."SBTSId" || '%' --obligé de rajouter un test WHERE car il y a des lcid en double
  OR "nokia_LCELW"."managedObject_distName" IS NULL) AND
  ("nokia_LCELGW_lCelwIdList"."managedObject_distName" LIKE 'PLMN-PLMN/SBTS-%' || "nokia_WBTS"."SBTSId" || '%' --obligé de rajouter un test WHERE car il y a des lcid en double
  OR "nokia_LCELGW_lCelwIdList" IS NULL) 
ORDER BY
  "nokia_WCEL".name
;



--AJOUT DES EXTERNAL CELLS:
INSERT INTO t_topologie3g_nokia (
  "RNCName",
  "RNC_id",
  "WBTS_managedObject_distName",
  "name",
  "WCEL_managedObject_distName",
  "CId",
  "UARFCN",
  "LAC",
  "RAC",
  "SAC",
  "PriScrCode",
  "WCELMCC",
  "WCELMNC",
  "WCEL_PtxPrimaryCPICH"
  )

SELECT 
  'EXTERNAL',
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."managedObject_distName_parent" AS wbts_managedObject_distName,
  "nokia_EXUCE"."name",
  "nokia_EXUCE"."managedObject_distName" AS wcel_managedObject_distName,
  "nokia_EXUCE"."cId",
  "nokia_EXUCE"."uarfcnDl",
  "nokia_EXUCE"."lac",
  "nokia_EXUCE"."rac",
  "nokia_EXUCE"."sac",
  "nokia_EXUCE"."primScrmCode",
  "nokia_EXUCE".mcc AS wcelmcc,
  "nokia_EXUCE".mnc AS wcelmnc,
  "nokia_EXUCE"."primCpichTxPow" AS ptxprimarycpich
FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g_nokia  
  ON
	"nokia_EXUCE"."rncId" = t_topologie3g_nokia."RNC_id" AND
	"nokia_EXUCE"."cId" = t_topologie3g_nokia."CId"
WHERE
    t_topologie3g_nokia.name IS NULL  --Sert a  supprimer les vois externes entre RNC Nokia
ORDER BY
  "nokia_EXUCE".name;
