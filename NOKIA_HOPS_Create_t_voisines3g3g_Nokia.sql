DROP TABLE IF EXISTS t_voisines3g3g_nokia_intra;
CREATE TABLE t_voisines3g3g_nokia_intra AS

SELECT 
  "nokia_ADJS"."managedObject_version", 
  "nokia_ADJS"."managedObject_id", 
  "nokia_ADJS"."managedObject_distName" AS "ADJS_managedObject_distName",
  "nokia_ADJS"."managedObject_distName_parent" AS "WCEL_managedObject_distName",
  "nokia_ADJS"."managedObject_ADJS",
  'ADJS'::text AS object_type,
  topo_s."managedObject_WCEL" AS "LCIDS",
  topo_s.name AS name_s, 
  topo_s."RNC_id" AS rnc_id_s, 
  topo_s."CId" AS cid_s, 
  topo_s."SAC",
  topo_s."LAC", 
  topo_s."RAC",
  topo_s."UARFCN" AS "UARFCN_s",
  "nokia_ADJS"."TargetCellDN", --identifiant de la voisine
  "nokia_ADJS".name AS adjs_name,  --nom de la voisine
  topo_v."managedObject_WCEL" AS "LCIDV",
  "nokia_ADJS"."AdjsCI",
  "nokia_ADJS"."AdjsCPICHTxPwr",
  "nokia_ADJS"."AdjsDERR",
  "nokia_ADJS"."AdjsEcNoOffset",
  "nokia_ADJS"."AdjsLAC",
  "nokia_ADJS"."AdjsMCC",
  "nokia_ADJS"."AdjsMNC",
  "nokia_ADJS"."AdjsRAC",
  "nokia_ADJS"."AdjsRNCid",
  "nokia_ADJS"."AdjsSIB",
  "nokia_ADJS"."AdjsScrCode",
  "nokia_ADJS"."AdjsTxDiv",
  "nokia_ADJS"."AdjsTxPwrRACH",
  "nokia_ADJS"."HSDPAHopsIdentifier",
  "nokia_ADJS"."NrtHopsIdentifier",
  "nokia_ADJS"."RTWithHSDPAHopsIdentifier",
  "nokia_ADJS"."RtHopsIdentifier",
  "nokia_ADJS"."SRBHopsIdentifier",
  "nokia_HOPS"."managedObject_HOPS",
  "nokia_HOPS".name AS hops_name,
  "AdjsHCSpriority",
  "AdjsHCSthreshold",
  "AdjsPenaltyTime",
  "AdjsQoffset1",
  "AdjsQoffset2",
  "AdjsQqualMin",
  "AdjsQrxlevMin",
  "AdjsTempOffset1",
  "AdjsTempOffset2",
  "EcNoAveragingWindow",
  "EnableInterRNCsho",
  "EnableRRCRelease",
  "HHOMarginAverageEcNo",
  "HHOMarginPeakEcNo",
  "HOPSChangeOrigin",
  "HSDPAAvailabilityIur",
  "HSUPAAvailabilityIur",
  "ReleaseMarginAverageEcNo",
  "ReleaseMarginPeakEcNo"
  
FROM 
  public."nokia_ADJS" LEFT JOIN public.t_topologie3g_nokia AS topo_s
  ON
	"nokia_ADJS"."managedObject_distName_parent" = topo_s."WCEL_managedObject_distName"
  LEFT JOIN public.t_topologie3g_nokia AS topo_v
  ON
    "nokia_ADJS"."TargetCellDN" = topo_v."WCEL_managedObject_distName"
  LEFT JOIN public."nokia_HOPS"
  ON
	"nokia_ADJS"."RtHopsIdentifier" = "nokia_HOPS"."managedObject_HOPS" AND
	"nokia_HOPS"."managedObject_distName_parent" = topo_s."RNC_managedObject_distName" --utilité ?

  
ORDER BY
  topo_s.name ASC, 
  "nokia_ADJS".name ASC;
