SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.primaryscramblingcode_s, 
  t_voisines3g3g.locationareacode_s, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.primaryscramblingcode_v, 
  t_voisines3g3g.locationareacode_v
FROM 
  public.t_voisines3g3g
WHERE 
  t_voisines3g3g.dlfrequencynumber_s IS NULL  OR 
  t_voisines3g3g.dlfrequencynumber_v IS NULL 
ORDER BY
  t_voisines3g3g.fddcell ASC,
  umtsfddneighbouringcell ASC;
