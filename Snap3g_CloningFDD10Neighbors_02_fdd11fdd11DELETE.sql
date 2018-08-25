SELECT 
  t_voisines3g3g.fddcell,
  t_voisines3g3g.localcellid_s AS lcids,
  t_topologie3g.codenidt,
  t_voisines3g3g.umtsfddneighbouringcell,
  t_voisines3g3g.localcellid_v AS lcidv,
  'S' AS Operation,
  'Clonage fdd10-fdd10' AS commentaire
FROM 
  public.t_voisines3g3g LEFT JOIN public.t_vois_fdd11fdd11_clonefdd10
  ON
    t_vois_fdd11fdd11_clonefdd10.fddcell = t_voisines3g3g.fddcell AND
    t_vois_fdd11fdd11_clonefdd10.umtsfddneighbouringcell = t_voisines3g3g.umtsfddneighbouringcell
  INNER JOIN t_topologie3g 
  ON t_voisines3g3g.fddcell = t_topologie3g.fddcell
WHERE
  t_vois_fdd11fdd11_clonefdd10.fddcell IS NULL AND
  t_voisines3g3g.dlfrequencynumber_s = '10812' AND
  t_voisines3g3g.dlfrequencynumber_v = '10812'
ORDER BY
  t_voisines3g3g.fddcell,
  t_voisines3g3g.umtsfddneighbouringcell;
