SELECT 
  t_fddcell_list_generic_corrections.fddcell, 
  t_fddcell_list_generic_corrections.localcellid AS LCID, 
  'FDDCell_' || t_fddcell_list_generic_corrections.param_name AS parametre,
  string_agg(param_value,',') AS valeur,
  'maj massive' AS commentaire
  
FROM 
  public.t_fddcell_list_generic_corrections
GROUP BY 
  t_fddcell_list_generic_corrections.fddcell, 
  t_fddcell_list_generic_corrections.localcellid, 
  t_fddcell_list_generic_corrections.param_name
ORDER BY
  t_fddcell_list_generic_corrections.fddcell;
