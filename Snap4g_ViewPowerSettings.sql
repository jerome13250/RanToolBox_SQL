SELECT 
  snap4g_ltecell.enbequipment, 
  snap4g_ltecell.ltecell,
  snap4g_frequencyandbandwidth.dlearfcn, 
  snap4g_frequencyandbandwidth.dlbandwidth, 
  snap4g_ltecell.celldltotalpower, 
  snap4g_ltecellfdd.transmissionmode, 
  snap4g_poweroffsetconfiguration_1.referencesignalpower, 
  snap4g_poweroffsetconfiguration_1.primarysyncsignalpoweroffset, 
  snap4g_poweroffsetconfiguration_1.secondarysyncsignalpoweroffset, 
  snap4g_poweroffsetconfiguration_1.pbchpoweroffset, 
  snap4g_poweroffsetconfiguration_1.pcfichpoweroffset, 
  snap4g_poweroffsetconfiguration_1.phichpoweroffset, 
  snap4g_celll2dlconf.pdcchpowercontrolactivation, 
  snap4g_poweroffsetconfiguration_1.pdcchpoweroffsetsymbol1, 
  snap4g_poweroffsetconfiguration_1.pdcchpoweroffsetsymbol2and3, 
  snap4g_poweroffsetconfiguration_1.paoffsetpdsch, 
  snap4g_poweroffsetconfiguration_1.pboffsetpdsch
FROM 
  public.snap4g_ltecell 
  LEFT JOIN public.snap4g_poweroffsetconfiguration_1 
  ON 
	snap4g_ltecell.ltecell = snap4g_poweroffsetconfiguration_1.ltecell AND
	snap4g_ltecell.enb = snap4g_poweroffsetconfiguration_1.enb
  LEFT JOIN public.snap4g_ltecellfdd 
  ON 
	snap4g_ltecell.ltecell = snap4g_ltecellfdd.ltecell AND
	snap4g_ltecell.enbequipment = snap4g_ltecellfdd.enbequipment
  LEFT JOIN  public.snap4g_celll2dlconf
  ON 
	snap4g_ltecell.enbequipment = snap4g_celll2dlconf.enbequipment AND
	snap4g_ltecell.ltecell = snap4g_celll2dlconf.ltecell
  LEFT JOIN  public.snap4g_frequencyandbandwidth
  ON 
	snap4g_ltecell.ltecell = snap4g_frequencyandbandwidth.ltecell
	
    
ORDER BY
  snap4g_ltecell.ltecell ASC;
