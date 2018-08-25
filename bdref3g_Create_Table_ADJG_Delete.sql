--création de la table des suppressions ADJG, le ADJG id sera rajouté plus tard:
--A NOTER: je ne fais pas de nettoyage de la liste des adjg disponible car nokia autorise les adjgid de 0 à 95 alors que bdref autorise que 32 vois
--donc on aura jamais de collision.
DROP TABLE IF EXISTS t_adjg_generic_delete; 
CREATE TABLE t_adjg_generic_delete AS

SELECT 
  t_voisines3g2g_nokia."ADJGid",
  t_voisines3g2g_nokia."managedObject_distName",
  t_voisines3g2g_nokia."managedObject_version",
  bdref_visuincohtopo_vois_3g2g_nokia."NIDTs", 
  bdref_visuincohtopo_vois_3g2g_nokia."NOEUDs", 
  bdref_visuincohtopo_vois_3g2g_nokia."LCIDs", 
  bdref_visuincohtopo_vois_3g2g_nokia."NOMs", 
  bdref_visuincohtopo_vois_3g2g_nokia."NIDT2Gv", 
  bdref_visuincohtopo_vois_3g2g_nokia."NOEUD2Gv", 
  bdref_visuincohtopo_vois_3g2g_nokia."LACv", 
  bdref_visuincohtopo_vois_3g2g_nokia."CIv", 
  bdref_visuincohtopo_vois_3g2g_nokia."NOMv", 
  bdref_visuincohtopo_vois_3g2g_nokia."CLASSEs", 
  bdref_visuincohtopo_vois_3g2g_nokia."CLASSEv", 
  bdref_visuincohtopo_vois_3g2g_nokia."Etats", 
  bdref_visuincohtopo_vois_3g2g_nokia."Opération", 
  bdref_visuincohtopo_vois_3g2g_nokia."Type Incoh"
FROM 
  public.bdref_visuincohtopo_vois_3g2g_nokia INNER JOIN public.t_voisines3g2g_nokia
  ON
	bdref_visuincohtopo_vois_3g2g_nokia."LCIDs" = t_voisines3g2g_nokia."LCIDs" AND
	bdref_visuincohtopo_vois_3g2g_nokia."LACv" = t_voisines3g2g_nokia."AdjgLAC" AND
	bdref_visuincohtopo_vois_3g2g_nokia."CIv" = t_voisines3g2g_nokia."AdjgCI"
WHERE
  bdref_visuincohtopo_vois_3g2g_nokia."Etats" NOT IN ('gelée','enreparenting') AND
  bdref_visuincohtopo_vois_3g2g_nokia."Opération" ILIKE 'S%'; --Voisines en Suppression


