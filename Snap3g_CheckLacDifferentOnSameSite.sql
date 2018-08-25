SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.systemrelease, 
  t_topologie3g.fddcell, 
  t_topologie3g.cellid, 
  t_topologie3g.alcatel_cellcode_ct, 
  t_topologie3g.dlfrequencynumber, 
  t_topologie3g.localcellid, 
  t_topologie3g.locationareacode, 
  t_topologie3g.primaryscramblingcode, 
  t_topologie3g.mobilecountrycode, 
  t_topologie3g.mobilenetworkcode, 
  t_topologie3g.administrativestate, 
  t_topologie3g.operationalstate, 
  t_topologie3g.availabilitystatus, 
  topo2.fddcell AS fddcell2, 
  topo2.locationareacode AS locationareacode2
FROM 
  public.t_topologie3g INNER JOIN public.t_topologie3g topo2
  ON 
    t_topologie3g.nodeb = topo2.nodeb
WHERE  
    topo2.locationareacode <> t_topologie3g.locationareacode
    AND t_topologie3g.mobilenetworkcode = topo2.mobilenetworkcode
    AND t_topologie3g.nodeb <> '' --Evite de calculer les EXTERNAL sans nodeB
ORDER BY
    t_topologie3g.fddcell;
