SELECT DISTINCT
  snap3g_dluserservice.radioaccessservice, 
  snap3g_dluserservice.dluserservice, 
  snap3g_dluserservice.isalwaysonallowed
FROM 
  public.snap3g_dluserservice

ORDER BY
  snap3g_dluserservice.dluserservice ASC;
