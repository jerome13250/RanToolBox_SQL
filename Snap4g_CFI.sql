SELECT 
  snap4g_enbequipment.enbequipment, 
  snap4g_enbequipment.systemrelease, 
  snap4g_enbequipment.administrativestate, 
  snap4g_enbequipment.operationalstate, 
  snap4g_enbequipment.availabilitystatus, 
  snap4g_celll1l2controlchannelsconf.ltecell, 
  snap4g_celll1l2controlchannelsconf.dynamiccfienabled, 
  snap4g_celll1l2controlchannelsconf.cfi1allowed, 
  snap4g_celll1l2controlchannelsconf.cfi2allowed, 
  snap4g_celll1l2controlchannelsconf.cfi3allowed, 
  snap4g_celll1l2controlchannelsconf.cfithreshold1, 
  snap4g_celll1l2controlchannelsconf.cfithreshold2
FROM 
  public.snap4g_celll1l2controlchannelsconf, 
  public.snap4g_enbequipment
WHERE 
  snap4g_enbequipment.enbequipment = snap4g_celll1l2controlchannelsconf.enbequipment
ORDER BY
  snap4g_celll1l2controlchannelsconf.ltecell ASC;
