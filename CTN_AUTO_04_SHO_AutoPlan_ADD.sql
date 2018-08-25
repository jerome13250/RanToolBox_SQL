SELECT 
  * 
FROM 
  public.t_ctn_autoplan_sho_limit31
WHERE 
  t_ctn_autoplan_sho_limit31.nbshoplusdetected < 1000000 --Ce sont les voisines HS mais declarees
   AND t_ctn_autoplan_sho_limit31.neighbor_type != 'NEIGHBOR';
