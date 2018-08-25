SELECT 
  snap4g_ulpowercontrolconf.ltecell, 
  snap4g_ulpowercontrolconf.deltafpucchformat1, 
  snap4g_ulpowercontrolconf.deltafpucchformat1b, 
  snap4g_uplinkcaconf.deltafpucchformat1bcsr10, 
  snap4g_ulpowercontrolconf.deltafpucchformat2, 
  snap4g_ulpowercontrolconf.deltafpucchformat2a, 
  snap4g_ulpowercontrolconf.deltafpucchformat2b, 
  snap4g_uplinkcaconf.deltafpucchformat3r10, 
  snap4g_ulpowercontrolconf.p0nominalpucch, 
  snap4g_ulpowercontrolconf.p0uepucch, 
  snap4g_ulpowercontrolconf.sirtargetforreferencepucchformat, 
  snap4g_celll2ulconf.isdci3forpucchpowercontrolallowed, 
  substr(snap4g_ltecell.spare7::bigint::bit(32)::text, 20, 1) AS "spare7_bit20_isSRNoiseUsedForPowerControl", 
  snap4g_celll2ulconf.isiotawareolpcconfenabled, 
  snap4g_cellradioconf.nominalpucchrotforolpc, 
  snap4g_cellradioconf.acceptablepucchrotrangeforolpc, 
  snap4g_cellradioconf.pucchrotfactorforolpc, 
  snap4g_celll1l2controlchannelsconf.ispcqibasedpucchpowercontrolenabled, 
  snap4g_celll1l2controlchannelsconf.isstaggeredacqiwithpcqienabled, 
  snap4g_ulpowercontrolconf.pUCCHpowerIncreaseCapMode
FROM 
  public.snap4g_ulpowercontrolconf, 
  public.snap4g_uplinkcaconf, 
  public.snap4g_celll2ulconf, 
  public.snap4g_cellradioconf, 
  public.snap4g_celll1l2controlchannelsconf, 
  public.snap4g_ltecell
WHERE 
  snap4g_ulpowercontrolconf.ltecell = snap4g_uplinkcaconf.ltecell AND
  snap4g_ulpowercontrolconf.ltecell = snap4g_celll1l2controlchannelsconf.ltecell AND
  snap4g_uplinkcaconf.ltecell = snap4g_celll2ulconf.ltecell AND
  snap4g_celll2ulconf.ltecell = snap4g_cellradioconf.ltecell AND
  snap4g_cellradioconf.ltecell = snap4g_ltecell.ltecell
ORDER BY
  snap4g_ulpowercontrolconf.ltecell ASC;
