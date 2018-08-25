SELECT 
  snap3g_neighbouringrnc.rnc, 
  snap3g_neighbouringrnc.neighbouringrnc, 
  snap3g_neighbouringrnc.administrativestate, 
  snap3g_neighbouringrnc.operationalstate, 
  snap3g_neighbouringrnc.availabilitystatus, 
  snap3g_rnc.rnc AS InternalOMC_rnc
FROM 
  public.snap3g_neighbouringrnc LEFT JOIN public.snap3g_rnc ON snap3g_neighbouringrnc.neighbouringrnc = snap3g_rnc.rncid
WHERE 
  snap3g_neighbouringrnc.operationalstate LIKE 'disabled'
ORDER BY
  snap3g_neighbouringrnc.rnc ASC, 
  snap3g_neighbouringrnc.neighbouringrnc ASC;
