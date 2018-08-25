SELECT 
  snap3g_dluserservice.rnc, 
  snap3g_dluserservice.radioaccessservice, 
  snap3g_dluserservice.dluserservice, 
  snap3g_dluserservice.isalwaysonallowed
FROM 
  public.snap3g_dluserservice
WHERE 
  snap3g_dluserservice.dluserservice LIKE 'CS_AMR_NBxPS_0K_IB_MUXxSRB_3_4K'
ORDER BY
  snap3g_dluserservice.dluserservice ASC;
