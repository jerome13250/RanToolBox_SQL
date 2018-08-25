DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_corrections;
CREATE TABLE t_umtsfddneighbouringcell_generic_corrections AS

SELECT 
  topo1.rnc, 
  topo1.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  topo1.nodeb, 
  topo1.fddcell, 
  topo2.fddcell AS umtsfddneighbouringcell,
  "Paramètre" AS parametre,
  "Valeur" AS valeur
FROM 
  public.bdref_visuincohparam_vois INNER JOIN public.t_topologie3g AS topo1
  ON
	bdref_visuincohparam_vois."LCIDs" = topo1.localcellid
  INNER JOIN public.t_topologie3g AS topo2
  ON
	bdref_visuincohparam_vois."LCIDv" = topo2.localcellid
  INNER JOIN public.snap3g_rnc
  ON 
	topo1.rnc = snap3g_rnc.rnc
;
