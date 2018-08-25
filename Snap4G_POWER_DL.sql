SELECT 
  snap4g_ltecell.ltecell, 
  snap4g_ltecell.celldltotalpower, 
  snap4g_ltecellfdd.transmissionmode, 
  snap4g_poweroffsetconfiguration_1.referencesignalpower, 
  snap4g_txpowerdynamicrange_1.maxrefsigpower, 
  snap4g_txpowerdynamicrange_1.minrefsigpower, 
  snap4g_poweroffsetconfiguration_1.primarysyncsignalpoweroffset, 
  snap4g_poweroffsetconfiguration_1.secondarysyncsignalpoweroffset, 
  snap4g_poweroffsetconfiguration_1.pbchpoweroffset, 
  snap4g_poweroffsetconfiguration_1.pcfichpoweroffset, 
  snap4g_poweroffsetconfiguration_1.phichpoweroffset, 
  snap4g_celll2dlconf.pdcchpowercontrolactivation, 
  snap4g_poweroffsetconfiguration_1.pdcchpoweroffsetsymbol1, 
  snap4g_poweroffsetconfiguration_1.pdcchpoweroffsetsymbol2and3, 
  snap4g_poweroffsetconfiguration_1.paoffsetpdsch, 
  snap4g_poweroffsetconfiguration_1.port5poweroffset, 
  snap4g_poweroffsetconfiguration_1.port7port8poweroffset, 
  snap4g_celll2dlconf.nompdschrsepreoffset, 
  snap4g_downlinkcaconf.cqireportconfigr10nompdschrsepreoffset
FROM 
  public.snap4g_ltecell, 
  public.snap4g_poweroffsetconfiguration_1, 
  public.snap4g_txpowerdynamicrange_1, 
  public.snap4g_ltecellfdd, 
  public.snap4g_celll2dlconf, 
  public.snap4g_downlinkcaconf
WHERE 
  snap4g_ltecell.ltecell = snap4g_poweroffsetconfiguration_1.ltecell AND
  snap4g_ltecell.ltecell = snap4g_ltecellfdd.ltecell AND
  snap4g_ltecell.ltecell = snap4g_celll2dlconf.ltecell AND
  snap4g_ltecell.ltecell = snap4g_downlinkcaconf.ltecell AND
  snap4g_poweroffsetconfiguration_1.ltecell = snap4g_txpowerdynamicrange_1.ltecell
ORDER BY
  snap4g_ltecell.ltecell ASC;
