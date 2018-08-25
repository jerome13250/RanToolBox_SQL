
SELECT 
  t_swap_l2100_10mhz_voisalufdd7."NOMs", 
  t_swap_l2100_10mhz_voisalufdd7."LCIDs", 
  t_swap_l2100_10mhz_voisalufdd7."NOMv", 
  t_swap_l2100_10mhz_voisalufdd7."LCIDv", 
  t_swap_l2100_10mhz_voisalufdd7."Opération" AS "Operation"
FROM 
  public.t_swap_l2100_10mhz_voisalufdd7

ORDER BY 
  "NOMs",
  "NOMv";