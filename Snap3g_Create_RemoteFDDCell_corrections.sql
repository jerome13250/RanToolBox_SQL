DROP TABLE IF EXISTS t_remotefddcell_generic_corrections;
CREATE TABLE t_remotefddcell_generic_corrections AS

SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_rnc.clusterid, 
  snap3g_remotefddcell.remotefddcell, 
  'neighbouringFDDCellId'::text AS param_name,
  t_topologie3g.cellid AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g
  ON
	snap3g_remotefddcell.remotefddcell = t_topologie3g.fddcell
  INNER JOIN public.snap3g_rnc
  ON
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE 
  snap3g_remotefddcell.neighbouringfddcellid != t_topologie3g.cellid
ORDER BY 
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.remotefddcell;
