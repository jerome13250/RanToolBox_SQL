DROP TABLE IF EXISTS t_gsmneighbouringcell_generic_corrections;
CREATE TABLE t_gsmneighbouringcell_generic_corrections AS

SELECT DISTINCT
  topo1.rnc, 
  topo1.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  topo1.nodeb, 
  topo1.fddcell, 
  topo_gsm.gsmcell AS gsmneighbouringcell,
  "Paramètre" AS parametre,
  "Valeur" AS valeur
FROM 
  public.bdref_visuincohparam_vois_3g2g INNER JOIN public.t_topologie3g AS topo1
  ON
	bdref_visuincohparam_vois_3g2g."LCIDs" = topo1.localcellid
  INNER JOIN public.t_topologie2gfrom3g AS topo_gsm
  ON
	bdref_visuincohparam_vois_3g2G."LACv" = topo_gsm.locationareacode AND
	bdref_visuincohparam_vois_3g2G."CIv" = topo_gsm.ci
	
  INNER JOIN public.snap3g_rnc
  ON 
	topo1.rnc = snap3g_rnc.rnc
;
