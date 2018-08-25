SELECT 
  snap3g_rfcarrier.btsequipment AS "BTSEquipment", 
  snap3g_rfcarrier.rfcarrier AS "RfCarrier",
  'icemNever' AS "hspaHardwareAllocation",

  --Info only:
  snap3g_rfcarrier.hspahardwareallocation AS info_hspahardwareallocation
FROM 
  public.snap3g_rfcarrier, 
  public.opteo_module_detection_3g_vam
WHERE 
  snap3g_rfcarrier.btsequipment = opteo_module_detection_3g_vam."NODEB"
ORDER BY
  snap3g_rfcarrier.btsequipment ASC, 
  snap3g_rfcarrier.rfcarrier ASC;
