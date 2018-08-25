--Cree la liste des neighbourcellprio utilisés, cette table servira a allouer des neighbourcellprio aux voisines en cours de creation
DROP TABLE IF EXISTS t_umtsneighbouringcell_neighbourcellprio;
CREATE TABLE t_umtsneighbouringcell_neighbourcellprio AS

SELECT 
  snap3g_umtsfddneighbouringcell.fddcell, 
  snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell, 
  snap3g_umtsfddneighbouringcell.neighbourcellprio
FROM 
  public.snap3g_umtsfddneighbouringcell;


--Liste les voisines a supprimer:
DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_delete;
CREATE TABLE t_umtsfddneighbouringcell_generic_delete AS

SELECT 
  topo1.rnc, 
  topo1.provisionedsystemrelease, 
  topo1.clusterid, 
  topo1.nodeb, 
  topo1.runningsoftwareversion, 
  topo1.fddcell, 
  topo2.fddcell AS umtsfddneighbouringcell
FROM 
  public.bdref_visuincohtopo_vois LEFT JOIN public.t_topologie3g topo1
  ON 
	bdref_visuincohtopo_vois."LCIDs" = topo1.localcellid
  LEFT JOIN public.t_topologie3g topo2
  ON 
	bdref_visuincohtopo_vois."LCIDv" = topo2.localcellid
WHERE
  "Opération" LIKE 'S%';

--Destruction des voisines dans la table des neighbourcellprio pour libérer des ncprio:
DELETE FROM t_umtsneighbouringcell_neighbourcellprio AS ncprio 
USING t_umtsfddneighbouringcell_generic_delete AS ntodelete 
WHERE 
	ncprio.fddcell = ntodelete.fddcell AND
	ncprio.umtsfddneighbouringcell = ntodelete.umtsfddneighbouringcell;







