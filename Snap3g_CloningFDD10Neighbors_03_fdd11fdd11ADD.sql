SELECT 
  t_vois_fdd11fdd11_clonefdd10.fddcell, 
  topo1.localcellid AS lcids,
  topo1.codenidt, 
  t_vois_fdd11fdd11_clonefdd10.umtsfddneighbouringcell, 
  topo2.localcellid AS lcidv,
  'A' AS Operation,
  'Clonage massif fdd10-fdd10' AS commentaire
FROM 
  public.t_vois_fdd11fdd11_clonefdd10 INNER JOIN public.t_topologie3g AS topo1 ON t_vois_fdd11fdd11_clonefdd10.fddcell = topo1.fddcell 
  INNER JOIN public.t_topologie3g AS topo2 ON t_vois_fdd11fdd11_clonefdd10.umtsfddneighbouringcell = topo2.fddcell
  LEFT JOIN t_voisines3g3g ON 
     (t_vois_fdd11fdd11_clonefdd10.fddcell = t_voisines3g3g.fddcell AND
     t_vois_fdd11fdd11_clonefdd10.umtsfddneighbouringcell = t_voisines3g3g.umtsfddneighbouringcell)
WHERE 
  t_voisines3g3g.fddcell IS NULL
ORDER BY
  t_vois_fdd11fdd11_clonefdd10.fddcell,
  t_vois_fdd11fdd11_clonefdd10.umtsfddneighbouringcell;
