DROP TABLE IF EXISTS t_calltrace_nbneigbdeclaredinter;

CREATE TABLE t_calltrace_nbneigbdeclaredinter AS
SELECT 
  fddcell,
  count(fddcell) AS nbvoisinter
FROM 
  public.t_voisines3g3g
WHERE 
  dlfrequencynumber_s != dlfrequencynumber_v
GROUP BY
  fddcell;
