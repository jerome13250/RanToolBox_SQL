DROP TABLE IF EXISTS t_visuincohtopo_remotefddcell_missing;
CREATE TABLE t_visuincohtopo_remotefddcell_missing AS

SELECT DISTINCT
  topo1.rnc,
  topo2.fddcell AS remotefddcell_missing
FROM 
  public.bdref_visuincohtopo_vois INNER JOIN public.t_topologie3g topo1
  ON 
	bdref_visuincohtopo_vois."LCIDs" = topo1.localcellid
  INNER JOIN public.t_topologie3g topo2
  ON 
	bdref_visuincohtopo_vois."LCIDv" = topo2.localcellid
  LEFT JOIN public.snap3g_remotefddcell
   ON
	topo1.rnc = snap3g_remotefddcell.rnc AND
	topo2.fddcell = snap3g_remotefddcell.remotefddcell
WHERE 
  topo1.rnc != topo2.rnc AND --pas sur le meme RNC
  snap3g_remotefddcell.rnc IS NULL--pas dans la table RemoteFDDCell
  
ORDER BY
 topo1.rnc
 ;