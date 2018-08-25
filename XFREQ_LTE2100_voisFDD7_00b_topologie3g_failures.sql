SELECT 
  nodeb, 
  fddcell, 
  localcellid, 
  "X", 
  "Y"
FROM 
  public.t_vois_xfreql2100_00_topo
WHERE
  "X" is null
ORDER BY
  fddcell;
