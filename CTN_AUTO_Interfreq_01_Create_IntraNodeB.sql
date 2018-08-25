SELECT 
  fddcell1.rnc, 
  fddcell1.nodeb, 
  fddcell1.fddcell, 
  fddcell1.dlfrequencynumber, 
  fddcell1.localcellid, 
  fddcell1.locationareacode, 
  fddcell1.administrativestate, 
  fddcell1.operationalstate, 
  fddcell1.availabilitystatus, 
  --fddcell1.azimuth, 
  fddcell2.fddcell AS umtsfddneighbouringcell, 
  fddcell2.dlfrequencynumber, 
  fddcell2.localcellid, 
  fddcell2.locationareacode, 
  fddcell2.administrativestate, 
  fddcell2.operationalstate, 
  fddcell2.availabilitystatus 
  --fddcell2.azimuth
FROM 
  public.snap3g_fddcell fddcell1, 
  public.snap3g_fddcell fddcell2
WHERE 
  fddcell1.rnc = fddcell2.rnc AND
  fddcell1.nodeb = fddcell2.nodeb AND 
  fddcell1.fddcell != fddcell2.fddcell
ORDER BY
  fddcell1.fddcell ASC, 
  fddcell2.fddcell ASC;
