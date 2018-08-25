SELECT 
  rnc,
  count(rnc)
FROM 
  public.t_fddcell_generic_corrections_new
GROUP BY 
  rnc
ORDER BY
  rnc ;
