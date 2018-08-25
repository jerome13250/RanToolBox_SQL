SELECT 
  snap3g_radioaccessservice.rnc, 
  snap3g_radioaccessservice.issib19allowed, 
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.sib19enable, 
  snap3g_fddcell.cellselectionwithpriorityprofileid
FROM 
  public.snap3g_radioaccessservice, 
  public.snap3g_fddcell
WHERE 
  snap3g_radioaccessservice.rnc = snap3g_fddcell.rnc
ORDER BY
  snap3g_fddcell.fddcell ASC;
