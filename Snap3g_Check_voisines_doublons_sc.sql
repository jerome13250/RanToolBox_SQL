SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.rncid_s, 
  t_voisines3g3g.nodeb_s, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.localcellid_s, 
  string_agg(t_voisines3g3g.umtsfddneighbouringcell, '-'), 
  string_agg(t_voisines3g3g.localcellid_v, '-'),
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.primaryscramblingcode_v,
  COUNT(primaryscramblingcode_v)
FROM 
  public.t_voisines3g3g

GROUP BY
  t_voisines3g3g.rnc, 
  t_voisines3g3g.rncid_s, 
  t_voisines3g3g.nodeb_s, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.primaryscramblingcode_v
HAVING
  COUNT(primaryscramblingcode_v)>1
ORDER BY
  t_voisines3g3g.fddcell,
  t_voisines3g3g.primaryscramblingcode_v ASC;
