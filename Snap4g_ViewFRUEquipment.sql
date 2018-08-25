SELECT 
  * 
FROM 
  public.snap4g_fru
WHERE 
  snap4g_fru.vendorunitfamilytype = 'RFM'
ORDER BY
  snap4g_fru.enbequipment ASC;
