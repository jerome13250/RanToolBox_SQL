SELECT 
  snap3g_gsmneighbouringcell.rnc, 
  snap3g_gsmneighbouringcell.fddcell, 
  snap3g_fddcell.dlfrequencynumber, 
  snap3g_gsmneighbouringcell.gsmneighbouringcell, 
  snap3g_gsmcell.userspecificinfo, 
  snap3g_gsmcell.locationareacode, 
  snap3g_gsmcell.ci, 
  snap3g_gsmcell.ncc, 
  snap3g_gsmcell.bcc, 
  snap3g_gsmcell.bcchfrequency
FROM 
  public.snap3g_gsmneighbouringcell, 
  public.snap3g_gsmcell, 
  public.snap3g_fddcell
WHERE 
  snap3g_gsmneighbouringcell.rnc = snap3g_gsmcell.rnc AND
  snap3g_gsmneighbouringcell.gsmneighbouringcell = snap3g_gsmcell.gsmcell AND
  snap3g_fddcell.rnc = snap3g_gsmneighbouringcell.rnc AND
  snap3g_fddcell.fddcell = snap3g_gsmneighbouringcell.fddcell AND
  snap3g_fddcell.dlfrequencynumber = '3011' AND 
  to_number(snap3g_gsmcell.bcchfrequency,'9G999') > 16
ORDER BY
  snap3g_gsmcell.bcchfrequency ASC;
