DROP TABLE IF EXISTS t_voisines3g3g_nokia_inter;
CREATE TABLE t_voisines3g3g_nokia_inter AS

SELECT DISTINCT
  "nokia_ADJI"."managedObject_version", 
  "nokia_ADJI"."managedObject_id", 
  "nokia_ADJI"."managedObject_distName" AS "ADJI_managedObject_distName",
  "nokia_ADJI"."managedObject_distName_parent" AS "WCEL_managedObject_distName",
  "nokia_ADJI"."managedObject_ADJI",
  'ADJI'::text AS object_type,
  topo_s."managedObject_WCEL",
  topo_s.name AS name_s, 
  topo_s."RNC_id" AS rnc_id_s, 
  topo_s."CId" AS cid_s,
  topo_s."SAC", 
  topo_s."LAC", 
  topo_s."RAC",
  topo_s."UARFCN" AS "UARFCN_s",
  "nokia_ADJI"."TargetCellDN", --identifiant de la voisine
  "nokia_ADJI".name AS adji_name,  --nom de la voisine
  topo_v."managedObject_WCEL" AS "LCIDV",
  "nokia_ADJI"."AdjiCI",
  "nokia_ADJI"."AdjiCPICHTxPwr",
  "nokia_ADJI"."AdjiLAC",
  "nokia_ADJI"."AdjiMCC",
  "nokia_ADJI"."AdjiMNC",
  "nokia_ADJI"."AdjiRAC",
  "nokia_ADJI"."AdjiRNCid",
  "nokia_ADJI"."AdjiSIB",
  "nokia_ADJI"."AdjiScrCode",
  "nokia_ADJI"."AdjiTxDiv",
  "nokia_ADJI"."AdjiTxPwrRACH",
  "nokia_ADJI"."AdjiUARFCN",
  "nokia_ADJI"."NrtHopiIdentifier",
  "nokia_ADJI"."RtHopiIdentifier",
  "nokia_HOPI"."managedObject_HOPI",
  "nokia_HOPI".name AS hopi_name,
  "AdjiHCSpriority",
  "AdjiHCSthreshold",
  "AdjiPenaltyTime",
  "AdjiQoffset1",
  "AdjiQoffset2",
  "AdjiQqualMin",
  "AdjiQrxlevMin",
  "AdjiTempOffset1",
  "AdjiTempOffset2",
  "HOPIChangeOrigin"
  
FROM 
  public."nokia_ADJI" LEFT JOIN public.t_topologie3g_nokia AS topo_s 
  ON
    "nokia_ADJI"."managedObject_distName_parent" = topo_s."WCEL_managedObject_distName"
  LEFT JOIN public.t_topologie3g_nokia AS topo_v
  ON
    "nokia_ADJI"."TargetCellDN" = topo_v."WCEL_managedObject_distName"
  LEFT JOIN public."nokia_HOPI"
  ON
    "nokia_ADJI"."RtHopiIdentifier" = "nokia_HOPI"."managedObject_HOPI" AND
    "nokia_HOPI"."managedObject_distName_parent" = topo_s."RNC_managedObject_distName"
ORDER BY
  topo_s.name ASC, 
  "nokia_ADJI".name ASC;
