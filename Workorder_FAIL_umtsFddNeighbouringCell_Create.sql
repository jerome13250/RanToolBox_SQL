SELECT 
  bdref_visuincohtopo_vois.*
FROM 
  public.bdref_visuincohtopo_vois LEFT JOIN public.t_umtsfddneighbouringcell_generic_creation_step3_final
  ON
  bdref_visuincohtopo_vois."LCIDs" = t_umtsfddneighbouringcell_generic_creation_step3_final.lcid_s AND
  bdref_visuincohtopo_vois."LCIDv" = t_umtsfddneighbouringcell_generic_creation_step3_final.lcid_v
WHERE 
  bdref_visuincohtopo_vois."Opération" LIKE 'A%' AND
  t_umtsfddneighbouringcell_generic_creation_step3_final.lcid_s IS NULL
ORDER BY "NOMs", "NOMv";
