SELECT 
  t_swap_l2100_10mhz_voisAlufdd7.*
FROM 
  public.t_swap_l2100_10mhz_voisAlufdd7 LEFT JOIN public.t_umtsfddneighbouringcell_generic_creation_step3_final
  ON
  t_swap_l2100_10mhz_voisAlufdd7."LCIDs" = t_umtsfddneighbouringcell_generic_creation_step3_final.lcid_s AND
  t_swap_l2100_10mhz_voisAlufdd7."LCIDv" = t_umtsfddneighbouringcell_generic_creation_step3_final.lcid_v
WHERE 
  t_swap_l2100_10mhz_voisAlufdd7."Opération" LIKE 'A%' AND
  t_umtsfddneighbouringcell_generic_creation_step3_final.lcid_s IS NULL
ORDER BY "NOMs", "NOMv";
