DROP TABLE IF EXISTS public.t_voisines3g2g_nokia;
CREATE TABLE public.t_voisines3g2g_nokia AS

SELECT 
  "nokia_ADJG"."managedObject_distName_parent" AS "WCEL_managedObject_distName", 
  "nokia_WCEL"."managedObject_WCEL" AS "LCIDs", 
  "nokia_WCEL".name AS name_s, 
  "nokia_ADJG"."managedObject_version", 
  "nokia_ADJG"."managedObject_id", 
  "nokia_ADJG"."managedObject_distName", 
  "nokia_ADJG"."managedObject_ADJG" AS "ADJGid", 
  "nokia_ADJG"."ADJGChangeOrigin", 
  "nokia_ADJG"."AdjgBCC", 
  "nokia_ADJG"."AdjgBCCH", 
  "nokia_ADJG"."AdjgBandIndicator", 
  "nokia_ADJG"."AdjgCI", 
  "nokia_ADJG"."AdjgLAC", 
  "nokia_ADJG"."AdjgMCC", 
  "nokia_ADJG"."AdjgMNC", 
  "nokia_ADJG"."AdjgNCC", 
  "nokia_ADJG"."AdjgSIB", 
  "nokia_ADJG"."AdjgTxPwrMaxRACH", 
  "nokia_ADJG"."AdjgTxPwrMaxTCH", 
  "nokia_ADJG"."NrtHopgIdentifier", 
  "nokia_ADJG"."RtHopgIdentifier", 
  "nokia_ADJG"."TargetCellDN", 
  "nokia_ADJG".defaults_name, 
  "nokia_ADJG".name
FROM 
  public."nokia_ADJG", 
  public."nokia_WCEL"
WHERE 
  "nokia_ADJG"."managedObject_distName_parent" = "nokia_WCEL"."managedObject_distName";
