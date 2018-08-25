--Correction du numero rncid et rac à 2 sur les remotefddcell des rnc voisins de celui du swap
DROP TABLE IF EXISTS t_remotefddcell_generic_corrections;
CREATE TABLE t_remotefddcell_generic_corrections AS
SELECT 
  snap3g_remotefddcell.remotefddcell, 
  snap3g_rnc.rnc, 
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease,
  'neighbouringRNCId'::text AS param_name,
  t_swap_l2100_10mhz_action.rncid_nokia AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_swap_l2100_10mhz_action 
  ON
	snap3g_remotefddcell.remotefddcell = t_swap_l2100_10mhz_action.fddcell
  INNER JOIN public.snap3g_rnc
  ON
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE 
  t_swap_l2100_10mhz_action.dlfrequencynumber NOT IN ('10812','10836')

UNION

SELECT 
  snap3g_remotefddcell.remotefddcell, 
  snap3g_rnc.rnc, 
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease,
  'routingAreaCode'::text AS param_name,
  '2'::text AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_swap_l2100_10mhz_action 
  ON
	snap3g_remotefddcell.remotefddcell = t_swap_l2100_10mhz_action.fddcell
  INNER JOIN public.snap3g_rnc
  ON
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE 
  t_swap_l2100_10mhz_action.dlfrequencynumber NOT IN ('10812','10836')

ORDER BY 
  remotefddcell,
  rnc,
  param_name


