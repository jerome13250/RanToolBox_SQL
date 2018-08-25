--Nettoie la topo NOKIA des doublons LCID cellules NOKIA en cours de création pour garder les cellules ALU toujours Online:
DELETE
FROM 
  public.t_topologie3g_nokia
WHERE
  "managedObject_WCEL"IN 
  (
  SELECT "managedObject_WCEL"
  FROM public.t_topologie3g_nokia
  GROUP BY "managedObject_WCEL"
  HAVING COUNT("managedObject_WCEL")>1 ) --LCID non unique 
  AND "AdminCellState" = '0' --
;


--Crée la liste de toutes les cellules avec modification vois 3g3g, cela permet de calculer les ADJid sur ce nombre restreint de cellules...
DROP TABLE IF EXISTS t_adjs_adji_list_servingcell;
CREATE TABLE t_adjs_adji_list_servingcell AS
SELECT DISTINCT
  bdref_visuincohtopo_vois_nokia."LCIDs" AS "LCID", 
  "nokia_WCEL"."managedObject_distName" AS "WCEL_managedObject_distName",
  "nokia_WCEL"."managedObject_version"
FROM 
  public.bdref_visuincohtopo_vois_nokia, 
  public."nokia_WCEL"
WHERE 
  bdref_visuincohtopo_vois_nokia."LCIDs" = "nokia_WCEL"."managedObject_WCEL";

--Crée la liste de tous les ADJSid et ADJIid possibles pour ces cellules:
DROP TABLE IF EXISTS t_adjs_adji_servingcell_all;
CREATE TABLE t_adjs_adji_servingcell_all AS
SELECT 
  t_adjs_adji_list_servingcell."LCID", 
  t_adjs_adji_list_servingcell."WCEL_managedObject_distName", 
  t_adjs_adji_list_servingcell."managedObject_version",
  t_nokia_adjs_adji_list.object_type, 
  t_nokia_adjs_adji_list.adjs_adji_list
FROM 
  public.t_adjs_adji_list_servingcell, --pas de jointure car on les veut tous
  public.t_nokia_adjs_adji_list;


--Crée la liste de tous les ADJSid et ADJIid disponibles:
DROP TABLE IF EXISTS t_adjs_adji_servingcell_available;
CREATE TABLE t_adjs_adji_servingcell_available AS
SELECT 
  t_adjs_adji_servingcell_all."LCID", 
  t_adjs_adji_servingcell_all."WCEL_managedObject_distName",
  t_adjs_adji_servingcell_all."managedObject_version",
  t_adjs_adji_servingcell_all.object_type, 
  t_adjs_adji_servingcell_all.adjs_adji_list
FROM 
  public.t_adjs_adji_servingcell_all LEFT JOIN public.t_voisines3g3g_nokia_intra
  ON
	t_adjs_adji_servingcell_all."WCEL_managedObject_distName" = t_voisines3g3g_nokia_intra."WCEL_managedObject_distName" AND
	t_adjs_adji_servingcell_all.object_type = t_voisines3g3g_nokia_intra.object_type AND
	t_adjs_adji_servingcell_all.adjs_adji_list = t_voisines3g3g_nokia_intra."managedObject_ADJS" 
  LEFT JOIN public.t_voisines3g3g_nokia_inter
  ON
	t_adjs_adji_servingcell_all."WCEL_managedObject_distName" = t_voisines3g3g_nokia_inter."WCEL_managedObject_distName" AND
	t_adjs_adji_servingcell_all.object_type = t_voisines3g3g_nokia_inter.object_type AND
	t_adjs_adji_servingcell_all.adjs_adji_list = t_voisines3g3g_nokia_inter."managedObject_ADJI"
  LEFT JOIN public.t_adjs_adji_generic_delete
  ON
	t_adjs_adji_servingcell_all."WCEL_managedObject_distName" = t_adjs_adji_generic_delete."WCEL_managedObject_distName" AND
	t_adjs_adji_servingcell_all.object_type = t_adjs_adji_generic_delete.object_type AND
	t_adjs_adji_servingcell_all.adjs_adji_list = t_adjs_adji_generic_delete."managedObject_ADJS"
WHERE
  ( t_voisines3g3g_nokia_intra."WCEL_managedObject_distName" IS NULL AND --On enleve les ADJSid déja utilisés
  t_voisines3g3g_nokia_inter."WCEL_managedObject_distName" IS NULL ) OR --On enleve les ADJIid déja utilisés
  t_adjs_adji_generic_delete."WCEL_managedObject_distName" IS NOT NULL --On rajoute les ADJSid et ADJIid qui ont été supprimés
  ;

--Ajout du ranking du adjs-adji id:
DROP TABLE IF EXISTS t_adjs_adji_servingcell_available_ranked;
CREATE TABLE t_adjs_adji_servingcell_available_ranked AS
SELECT 
  t_adjs_adji_servingcell_available.*,
  ROW_NUMBER() OVER (PARTITION BY "WCEL_managedObject_distName",object_type ORDER BY adjs_adji_list::int ASC) AS adjs_adji_ranking
FROM 
  public.t_adjs_adji_servingcell_available;

