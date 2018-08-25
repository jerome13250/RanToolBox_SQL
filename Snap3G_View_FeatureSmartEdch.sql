SELECT 
  snap3g_edchrncconf.rnc, 
  snap3g_edchrncconf.edchrncconf, 
  snap3g_edchrncconf.smartedchresourceusageactivation, 
  snap3g_edchrncconf.srbsmartedchresourceusageactivation
FROM 
  public.snap3g_edchrncconf
ORDER BY
  snap3g_edchrncconf.rnc ASC;
