DROP TABLE IF EXISTS t_CallTrace_NbNeigbDeclared;

CREATE TABLE t_CallTrace_NbNeigbDeclared AS
SELECT 
  fddcell,
  count(fddcell) AS nbvoisintra
FROM 
  public.t_voisines3g3g
WHERE 
  dlfrequencynumber_s = dlfrequencynumber_v
GROUP BY
  fddcell;
