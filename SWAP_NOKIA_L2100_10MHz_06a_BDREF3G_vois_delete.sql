SELECT 
  t_umtsfddneighbouringcell_generic_delete.fddcell AS "NOMs", 
  topos.localcellid AS "LCIDs", 
  t_umtsfddneighbouringcell_generic_delete.umtsfddneighbouringcell AS "NOMv", 
  topov.localcellid AS "LCIDv",
  'S'::text AS "Operation"
FROM 
  public.t_umtsfddneighbouringcell_generic_delete INNER JOIN public.t_topologie3g topos
  ON
	t_umtsfddneighbouringcell_generic_delete.fddcell = topos.fddcell
  INNER JOIN public.t_topologie3g topov
  ON
	t_umtsfddneighbouringcell_generic_delete.umtsfddneighbouringcell = topov.fddcell

ORDER BY 
  "NOMs",
  "NOMv"
;
