SELECT 
  t_topologie4g.ltecell, 
  t_topologie4g.eci, 
  t_topologie4g.dlbandwidth, 
  t_topologie4g.dlearfcn, 
  snap4g_ulpowercontrolconf.puschpowercontrolalphafactor, 
  snap4g_ulpowercontrolconf.p0nominalpusch, 
  snap4g_logicalchannelconf.p0uepusch, 
  snap4g_ulpowercontrolconf.isp0persistentfieldpresent, 
  snap4g_ulpowercontrolconf.p0nominalpuschpersistent, 
  snap4g_ulpowercontrolconf.p0uepuschpersistent, 
  snap4g_ulpowercontrolconf.filtercoefficient, 
  snap4g_celll2ulconf.isiotawareolpcconfenabled, 
  snap4g_cellradioconf.nominalpuschiotforolpc, 
  snap4g_cellradioconf.acceptablepuschiotrangeforolpc, 
  snap4g_cellradioconf.puschiotfactorforolpc, 
  snap4g_enbradioconf.criticalpuschtpcadjustthreshold, 
  snap4g_ulpowercontrolconf.iscqibasedpuschpowerctrlenabled, 
  snap4g_ulpowercontrolconf.dlsinrtoulsinrtargetconversionfactor, 
  snap4g_ulpowercontrolconf.dlsinrtoulsinrtargetconversionthresh, 
  snap4g_ulpowercontrolconf.accumulationenabled, 
  snap4g_cellradioconf.uplinksirtargetvaluefordynamicpuschscheduling, 
  snap4g_ulpowercontrolconf.pathlossnominal, 
  snap4g_ulpowercontrolconf.maxsirtargetforfractionalpowerctrl, 
  snap4g_ulpowercontrolconf.minsirtargetforfractionalpowerctrl, 
  snap4g_ulpowercontrolconf.puschiotcontrolactivationflag, 
  snap4g_ulpowercontrolconf.puschiotcontrolcoefabovethr1, 
  snap4g_ulpowercontrolconf.puschiotcontrolcoefbelowthr1, 
  snap4g_ulpowercontrolconf.puschiotcontrolmintargetcorrabovethr1, 
  snap4g_ulpowercontrolconf.puschiotcontrolmintargetcorrbelowthr1, 
  snap4g_ulpowercontrolconf.puschiotcontrolthermalnoisecorr, 
  snap4g_ulpowercontrolconf.puschiotcontrolthresh1, 
  snap4g_ulpowercontrolconf.puschiotcontrolthresh2, 
  snap4g_enbradioconf.isintersectoriotcontrolenabled, 
  snap4g_ulpowercontrolconf.intersectoriotcontrolmincellloadthr, 
  snap4g_ulpowercontrolconf.deltaiocontrolthreshold
FROM 
  public.t_topologie4g, 
  public.snap4g_ulpowercontrolconf, 
  public.snap4g_logicalchannelconf, 
  public.snap4g_celll2ulconf, 
  public.snap4g_cellradioconf, 
  public.snap4g_enbradioconf
WHERE 
  t_topologie4g.ltecell = snap4g_ulpowercontrolconf.ltecell AND
  t_topologie4g.enbequipment = snap4g_logicalchannelconf.enbequipment AND
  t_topologie4g.dedicatedconfid = snap4g_logicalchannelconf.dedicatedconf AND
  t_topologie4g.ltecell = snap4g_celll2ulconf.ltecell AND
  t_topologie4g.ltecell = snap4g_cellradioconf.ltecell AND
  t_topologie4g.enbequipment = snap4g_enbradioconf.enbequipment
ORDER BY
  t_topologie4g.ltecell ASC;
