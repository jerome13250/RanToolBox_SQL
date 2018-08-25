SELECT DISTINCT
  snap3g_alwaysonconf.isalwaysonallowed, 
  snap3g_alwaysonconf.alwaysondlrbsetdchid, 
  snap3g_alwaysonconf.alwaysonulrbsetdchid, 
  snap3g_alwaysonconf.alwaysondlrbsetfachid, 
  snap3g_alwaysonconf.alwaysonulrbsetfachid, 
  snap3g_dluserservice.dluserservice, 
  snap3g_dluserservice.isalwaysonallowed
FROM 
  public.snap3g_alwaysonconf, 
  public.snap3g_dluserservice
WHERE 
  snap3g_alwaysonconf.rnc = snap3g_dluserservice.rnc AND
  snap3g_alwaysonconf.radioaccessservice = snap3g_dluserservice.radioaccessservice
ORDER BY 
  snap3g_dluserservice.radioaccessservice
;
