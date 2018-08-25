SELECT 
  snap3g_hsdpaconf.btsequipment, 
  snap3g_hsdpaconf.btscell, 
  snap3g_hsdpaconf.hsdpaconf, 
  snap3g_hsdpaconf.administrativestate
FROM 
  public.snap3g_hsdpaconf
WHERE
  snap3g_hsdpaconf.administrativestate != 'unlocked';
