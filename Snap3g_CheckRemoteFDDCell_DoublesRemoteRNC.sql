SELECT 
  snap3g_remotefddcell.rnc AS declaration_rnc, 
  snap3g_remotefddcell.neighbouringrncid, 
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.localcellid AS remote_lcid, 
  snap3g_remotefddcell.locationareacode AS remote_lac
FROM 
  public.snap3g_remotefddcell
ORDER BY
  snap3g_remotefddcell.rnc ASC, 
  snap3g_remotefddcell.remotefddcell ASC;
