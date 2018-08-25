SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.rncid_s, 
  t_voisines3g3g.nodeb_s, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.rnc_v, 
  t_voisines3g3g.rncid_v, 
  t_voisines3g3g.nodeb_v, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.localcellid_v, 
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.sib11ordchusage
FROM 
  public.t_voisines3g3g
WHERE 
  t_voisines3g3g.dlfrequencynumber_s = '3011' AND
  t_voisines3g3g.dlfrequencynumber_v IN ('10812','10836','10712') AND
  t_voisines3g3g.sib11ordchusage != 'dchUsage' AND
  t_voisines3g3g.umtsfddneighbouringcell NOT LIKE 'SuperCell%';

