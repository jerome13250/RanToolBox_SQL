SELECT 
  snap3g_btsequipment.btsequipment,
  snap3g_btsequipment.associatednodeb,
  snap3g_btsequipment.operationalstate, 
  snap3g_btsequipment.availabilitystatus, 
  snap3g_btsequipment.oamlinkadministrativestate, 
  snap3g_btsequipment.unknownstatus
FROM 
  public.snap3g_btsequipment
WHERE 
  --snap3g_btsequipment.operationalstate != 'enabled' OR
  snap3g_btsequipment.unknownstatus = 'unknownstatustrue'
ORDER BY
  snap3g_btsequipment.btsequipment;