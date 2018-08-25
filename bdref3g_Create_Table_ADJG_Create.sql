--creation d'une table temporaire des visu incohs vois 3g2g avec les idcell (différents des LCID et LAC+CI):
DROP TABLE IF EXISTS tmp_bdref_visuincohtopo_vois_3g2g_nokia;
CREATE TABLE tmp_bdref_visuincohtopo_vois_3g2g_nokia AS
SELECT 
  bdref_visuincohtopo_vois_3g2g_nokia.*, 
  bdref_tmp_idcell_3g.idcell AS idcell_3g, 
  bdref_t_idcell_2g.idcell AS idcell_2g
FROM 
  public.bdref_visuincohtopo_vois_3g2g_nokia INNER JOIN public.bdref_tmp_idcell_3g
  ON
	bdref_visuincohtopo_vois_3g2g_nokia."LCIDs" = bdref_tmp_idcell_3g.lcid
  INNER JOIN public.bdref_t_idcell_2g
  ON
	bdref_visuincohtopo_vois_3g2g_nokia."LACv" = bdref_t_idcell_2g.lac AND
	bdref_visuincohtopo_vois_3g2g_nokia."CIv" = bdref_t_idcell_2g.ci 
WHERE 
  "Etats" IN ('OK','enintégration') AND
  "Opération" ILIKE 'A%' AND --Ajouts seulement
  "NOMs" != '' AND --supprime les serveuses non remontées OMC
  "NOMv" != '' AND --supprime les voisines non remontées
  "NOMv" != 'EXTERNE' --supprime les voisines EXTERNE
  ;  
  

--création de la table des informations ADJG, le ADJG id sera rajouté plus tard:
DROP TABLE IF EXISTS t_adjg_generic_create_step1;
CREATE TABLE t_adjg_generic_create_step1 AS

SELECT 
  "nokia_WCEL"."managedObject_version",
  "nokia_WCEL"."managedObject_distName",
  tmp_bdref_visuincohtopo_vois_3g2g_nokia.*,
  bdref_t_topologie_terrain_2g.nom, 
  bdref_t_topologie_terrain_2g.bcc, 
  bdref_t_topologie_terrain_2g.bcch, 
  bdref_t_topologie_terrain_2g.mcc, 
  bdref_t_topologie_terrain_2g.mnc, 
  bdref_t_topologie_terrain_2g.ncc,
  str_valeur AS "AdjgSIB"
FROM 
  public.tmp_bdref_visuincohtopo_vois_3g2g_nokia INNER JOIN public.bdref_t_topologie_terrain_2g
  ON
	tmp_bdref_visuincohtopo_vois_3g2g_nokia.idcell_2g = bdref_t_topologie_terrain_2g.ci
  INNER JOIN public."nokia_WCEL"
  ON
	tmp_bdref_visuincohtopo_vois_3g2g_nokia."LCIDs" = "nokia_WCEL"."managedObject_WCEL"
  INNER JOIN public.bdref_t_param_vois_3g2g_cible
  ON
	tmp_bdref_visuincohtopo_vois_3g2g_nokia.idcell_3g = bdref_t_param_vois_3g2g_cible."LCID_s" AND
	tmp_bdref_visuincohtopo_vois_3g2g_nokia.idcell_2g = bdref_t_param_vois_3g2g_cible."CI_v"
  
 WHERE
  tmp_bdref_visuincohtopo_vois_3g2g_nokia."Etats" NOT IN ('gelée','enreparenting') AND
  tmp_bdref_visuincohtopo_vois_3g2g_nokia."Opération" ILIKE 'A%'  --Voisines an Ajout
  AND bdref_t_param_vois_3g2g_cible.idx_param_vois = '20000011' --Code du paramètre "AdjgSIB"
;
  
--Creation de la liste de tous les ADJG possibles de 0 à 95
DROP TABLE IF EXISTS t_adjg_generic_create_adjgid_available;
CREATE TABLE t_adjg_generic_create_adjgid_available AS
SELECT distinct
  t_adjg_generic_create_step1."NOMs", 
  t_adjg_generic_create_step1."LCIDs", 
  t_nokia_adjg_list."adjg_list"
FROM 
  public.t_adjg_generic_create_step1, --pas de join car il nous faut toutes les valeurs possibles de 0 à 95
  public.t_nokia_adjg_list
ORDER BY 
  "NOMs",
  "LCIDs",
  "adjg_list";


--Suppression des ADJG id utilisés: 
DELETE FROM t_adjg_generic_create_adjgid_available AS adjgid_available
USING t_voisines3g2g_nokia
WHERE 
	adjgid_available."LCIDs" = t_voisines3g2g_nokia."LCIDs" AND
	adjgid_available.adjg_list = t_voisines3g2g_nokia."ADJGid";


--Ajout du ranking du adjgid:
DROP TABLE IF EXISTS t_adjg_generic_create_adjgid_available_ranked;
CREATE TABLE t_adjg_generic_create_adjgid_available_ranked AS
SELECT 
  adjgid_available.*,
  ROW_NUMBER() OVER (PARTITION BY "LCIDs" ORDER BY adjg_list::int ASC) AS adjgid_ranking
FROM 
  public.t_adjg_generic_create_adjgid_available AS adjgid_available;


--Ajout du ranking du voisinage à ajouter sur la table des voisines:
DROP TABLE IF EXISTS t_adjg_generic_create_step2;
CREATE TABLE t_adjg_generic_create_step2 AS
SELECT 
  t_adjg_generic_create_step1.*,
  ROW_NUMBER() OVER (PARTITION BY "LCIDs" ORDER BY "NOMs","LCIDs","NOMv") AS adjgid_ranking
FROM 
  public.t_adjg_generic_create_step1;


--Jointure des 2 tables ranked :
DROP TABLE IF EXISTS t_adjg_generic_create;
CREATE TABLE t_adjg_generic_create AS
SELECT 
  t_adjg_generic_create_step2.*, 
  t_adjg_generic_create_adjgid_available_ranked.adjg_list AS adjgid
FROM 
  public.t_adjg_generic_create_step2 INNER JOIN 
  public.t_adjg_generic_create_adjgid_available_ranked
  ON 
	t_adjg_generic_create_step2."LCIDs" = t_adjg_generic_create_adjgid_available_ranked."LCIDs" AND
	t_adjg_generic_create_step2.adjgid_ranking = t_adjg_generic_create_adjgid_available_ranked.adjgid_ranking;



