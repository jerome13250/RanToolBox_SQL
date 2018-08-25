SELECT 
  snap3g_btsequipment.btsequipment AS "BTSEquipment", 
  'true' AS "isVamAllowed"
FROM 
  public.opteo_module_detection_3g_vam, 
  public.snap3g_btsequipment
WHERE 
  opteo_module_detection_3g_vam."NODEB" = snap3g_btsequipment.btsequipment
ORDER BY
  snap3g_btsequipment.btsequipment;
