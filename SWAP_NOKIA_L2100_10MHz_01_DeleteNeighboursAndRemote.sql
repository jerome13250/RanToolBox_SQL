--ON retrouve le freqconfig du site pour dicriminer les cas FDD10 seul, bi-trifreq ou quadrifreq:
DROP TABLE IF EXISTS t_swap_l2100_10mhz_freqconf;
CREATE TABLE t_swap_l2100_10mhz_freqconf AS

SELECT
  "NIDT",
  rncid_nokia,
  nodeb,
  string_agg(dlfrequencynumber,'-') AS freq_config
  FROM (
	SELECT DISTINCT
	  "NIDT",
	  rncid_nokia,
	  nodeb,
	  dlfrequencynumber
	FROM 
	  public.t_swap_l2100_10mhz INNER JOIN public.t_topologie3g
	  ON 
	  t_swap_l2100_10mhz."NIDT" = t_topologie3g.codenidt
	WHERE 
	  dlfrequencynumber::int > 10000 -- ne considère pas les configs U900
	ORDER BY
	  dlfrequencynumber
	) AS t
GROUP BY
  "NIDT",
  rncid_nokia,
  nodeb;

--Donne les actions prévues en fonction pour chaque cellule:
DROP TABLE IF EXISTS t_swap_l2100_10mhz_action;
CREATE TABLE t_swap_l2100_10mhz_action AS

SELECT 
  t_topologie3g.fddcell,
  t_topologie3g.nodeb,
  t_topologie3g.localcellid,
  t_topologie3g.dlfrequencynumber, 
  t_swap_l2100_10mhz_freqconf."NIDT",
  t_swap_l2100_10mhz_freqconf.rncid_nokia,
  t_swap_l2100_10mhz_freqconf.freq_config,
  CASE 
	WHEN dlfrequencynumber = '10712' THEN 'future_fdd7'
	WHEN dlfrequencynumber = '10812' AND freq_config != '10712-10787-10812-10836' THEN 'future_fdd7'
	WHEN dlfrequencynumber = '10812' AND freq_config = '10712-10787-10812-10836' THEN 'destroy'
	WHEN dlfrequencynumber = '10836' THEN 'destroy'
	ELSE 'keep' 
  END AS action
	
FROM 
  public.t_topologie3g, 
  public.t_swap_l2100_10mhz_freqconf
WHERE 
  t_swap_l2100_10mhz_freqconf."NIDT" = t_topologie3g.codenidt
ORDER BY
  t_topologie3g.fddcell;



--Destruction des voisines entrantes FDD11 et FDD12:
DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_delete;
CREATE TABLE t_umtsfddneighbouringcell_generic_delete AS

SELECT 
  topo_s.rnc, 
  topo_s.provisionedsystemrelease, 
  topo_s.clusterid, 
  topo_s.nodeb, 
  topo_s.fddcell, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.dlfrequencynumber_v
FROM 
  public.t_swap_l2100_10mhz_freqconf INNER JOIN public.t_topologie3g topo_v
  ON
	t_swap_l2100_10mhz_freqconf."NIDT" = topo_v.codenidt
  INNER JOIN public.t_voisines3g3g
  ON
	topo_v.fddcell = t_voisines3g3g.umtsfddneighbouringcell
  INNER JOIN public.t_topologie3g topo_s
  ON
	t_voisines3g3g.fddcell = topo_s.fddcell
WHERE 
  t_voisines3g3g.dlfrequencynumber_v IN ('10812','10836')
ORDER BY
  topo_s.fddcell,
  t_voisines3g3g.umtsfddneighbouringcell
  ;


--Destruction des RemoteFDDCell FDD11 et FDD12:
DROP TABLE IF EXISTS t_remotefddcell_generic_delete;
CREATE TABLE t_remotefddcell_generic_delete AS

SELECT 
  snap3g_rnc.rnc, 
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_remotefddcell.remotefddcell, 
  t_topologie3g.dlfrequencynumber
FROM 
  public.snap3g_rnc INNER JOIN public.snap3g_remotefddcell
  ON 
	snap3g_rnc.rnc = snap3g_remotefddcell.rnc
  INNER JOIN public.t_topologie3g
  ON 
	snap3g_remotefddcell.remotefddcell = t_topologie3g.fddcell
  INNER JOIN public.t_swap_l2100_10mhz_freqconf
  ON
	t_topologie3g.codenidt = t_swap_l2100_10mhz_freqconf."NIDT"
WHERE 
  t_topologie3g.dlfrequencynumber IN ('10812','10836');






