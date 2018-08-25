SELECT 
  rnc,
  COUNT(rnc)
FROM 
  public.t_remotefddcell_generic_corrections
GROUP BY
  rnc
ORDER BY
  rnc;
