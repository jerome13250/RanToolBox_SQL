SELECT 
  rnc,
  COUNT(rnc)
FROM 
  public.t_fddcell_list_generic_corrections
GROUP BY
  rnc
ORDER BY
  rnc;
