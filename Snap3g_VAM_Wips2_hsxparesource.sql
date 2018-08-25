SELECT 
  snap3g_hsxparesource.btsequipment AS "BTSEquipment", 
  snap3g_hsxparesource.hsxparesource AS "HsXpaResource", 
  'eCEM' AS modempreference
FROM 
  public.opteo_module_detection_3g_vam, 
  public.snap3g_hsxparesource
WHERE 
  opteo_module_detection_3g_vam."NODEB" = snap3g_hsxparesource.btsequipment
ORDER BY
  snap3g_hsxparesource.btsequipment,
  snap3g_hsxparesource.hsxparesource;
