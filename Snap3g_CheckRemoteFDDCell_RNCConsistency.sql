SELECT 
  snap3g_remotefddcell.rnc AS declaration_rnc, 
  snap3g_remotefddcell.neighbouringrncid, 
  snap3g_rnc.rnc AS remote_rnc, 
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.localcellid AS remote_lcid, 
  snap3g_remotefddcell.locationareacode AS remote_lac, 
  snap3g_fddcell.rnc, 
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.localcellid, 
  snap3g_fddcell.locationareacode
FROM 
  public.snap3g_remotefddcell, 
  public.snap3g_fddcell, 
  public.snap3g_rnc
WHERE 
  snap3g_remotefddcell.neighbouringrncid = snap3g_rnc.rncid AND
  snap3g_remotefddcell.remotefddcell = snap3g_fddcell.fddcell AND
  snap3g_rnc.rnc NOT LIKE snap3g_fddcell.rnc
ORDER BY
  snap3g_remotefddcell.rnc ASC, 
  snap3g_remotefddcell.remotefddcell ASC;
