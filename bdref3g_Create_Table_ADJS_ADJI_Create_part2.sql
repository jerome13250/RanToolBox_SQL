--ANALYZE car exécution lente en java:
ANALYZE bdref_t_param_vois_cible;

--creation d'une table temporaire des visu incohs vois avec les idcell (différents des LCID) + suppression des vois deja existantes:
DROP TABLE IF EXISTS tmp_bdref_visuincohtopo_vois_nokia;
CREATE TABLE tmp_bdref_visuincohtopo_vois_nokia AS
SELECT 
  bdref_visuincohtopo_vois_nokia.*, 
  t_idcell_s.idcell AS idcell_s, 
  t_idcell_v.idcell AS idcell_v
FROM 
  public.bdref_visuincohtopo_vois_nokia INNER JOIN public.bdref_tmp_idcell_3g t_idcell_s
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = t_idcell_s.lcid
  INNER JOIN public.bdref_tmp_idcell_3g t_idcell_v
  ON
	bdref_visuincohtopo_vois_nokia."LCIDv" = t_idcell_v.lcid
  LEFT JOIN public.t_voisines3g3g_nokia_intra --jointure sur vois terrain intrafreq pour les supprimer si déja existantes
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = t_voisines3g3g_nokia_intra."LCIDS" AND
	bdref_visuincohtopo_vois_nokia."LCIDv" = t_voisines3g3g_nokia_intra."LCIDV" AND
	bdref_visuincohtopo_vois_nokia."Opération" ILIKE 'A%'
  LEFT JOIN public.t_voisines3g3g_nokia_inter --jointure sur vois terrain interfreq pour les supprimer si déja existantes
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = t_voisines3g3g_nokia_inter."managedObject_WCEL" AND
	bdref_visuincohtopo_vois_nokia."LCIDv" = t_voisines3g3g_nokia_inter."LCIDV" AND
	bdref_visuincohtopo_vois_nokia."Opération" ILIKE 'A%'
WHERE 
  t_voisines3g3g_nokia_intra."LCIDS" IS NULL AND --exclusion des intrafreq existantes
  t_voisines3g3g_nokia_inter."managedObject_WCEL" IS NULL --exclusion des interfreq existantes
ORDER BY
  bdref_visuincohtopo_vois_nokia."NOMs",
  bdref_visuincohtopo_vois_nokia."LCIDv";
  

--Recherche les params croisés dans la table bdref t_param_vois_cible
--ATTENTION :  ce sont en réalité des idcell dans t_param_vois_cible et pas des LCID
DROP TABLE IF EXISTS t_adjs_adji_parameters;
CREATE TABLE t_adjs_adji_parameters AS
SELECT 
  tmp_bdref_visuincohtopo_vois_nokia."LCIDs", 
  tmp_bdref_visuincohtopo_vois_nokia."LCIDv", 
  bdref_t_param_vois_cible.idx_param_vois, 
  bdref_t_param_vois_cible.str_valeur
FROM 
  public.bdref_t_param_vois_cible INNER JOIN public.tmp_bdref_visuincohtopo_vois_nokia
  ON 
  bdref_t_param_vois_cible."LCID_s" = tmp_bdref_visuincohtopo_vois_nokia.idcell_s AND     --BUG à corriger les idcell sont différents des LCID
  bdref_t_param_vois_cible."LCID_v" = tmp_bdref_visuincohtopo_vois_nokia.idcell_v
WHERE
  bdref_t_param_vois_cible.idx_param_vois LIKE '2%' AND --on restreint aux params Nokia pour accélerer la requete
  "Opération" = 'Ajout' AND 
  "Etats" IN ('OK','enintégration') AND
  "NOMs" != '' AND --supprime les serveuses non remontées OMC
  "NOMv" != '' AND --supprime les voisines non remontées
  "NOMv" != 'EXTERNE' --supprime les voisines EXTERNE
  ;
  
--ANALYZE car exécution lente en java:
ANALYZE t_adjs_adji_parameters;

--création d'une topo globale temporaire contenant toutes les informations uarfcn des 2 OMCs, la topo nokia ne contient pas toutes les cellules ALU
DROP TABLE IF EXISTS tmp_topologie3g_uarfcn_global;
CREATE TABLE tmp_topologie3g_uarfcn_global AS
SELECT 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_topologie3g_nokia."UARFCN"
FROM 
  public.t_topologie3g_nokia
WHERE 
  "managedObject_WCEL" IS NOT NULL AND
  "UARFCN" IS NOT NULL;

--rajout des alcatel:
INSERT INTO tmp_topologie3g_uarfcn_global
SELECT 
  t_topologie3g.localcellid, 
  t_topologie3g.dlfrequencynumber
FROM 
  public.t_topologie3g LEFT JOIN tmp_topologie3g_uarfcn_global
  ON
	t_topologie3g.localcellid = tmp_topologie3g_uarfcn_global."managedObject_WCEL"
WHERE 
  "managedObject_WCEL" IS NULL; --les lcid deja ALU sont exclus



--Discernement des ADJS ou ADJI: On jointe sur la topo omc nokia + alu, si une cellule n'est pas connue à l'omc le voisinage ne sera pas créé...
DROP TABLE IF EXISTS t_adjs_adji_discernement;
CREATE TABLE t_adjs_adji_discernement AS
SELECT 
  bdref_visuincohtopo_vois_nokia."LCIDs", 
  bdref_visuincohtopo_vois_nokia."NOMs", 
  topo_s."UARFCN", 
  bdref_visuincohtopo_vois_nokia."LCIDv", 
  bdref_visuincohtopo_vois_nokia."NOMv",
  topo_v."UARFCN" AS "UARFCNv", 
  'ADJS'::text AS object_type
FROM 
  public.bdref_visuincohtopo_vois_nokia INNER JOIN public.tmp_topologie3g_uarfcn_global topo_s
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = topo_s."managedObject_WCEL"
  INNER JOIN public.tmp_topologie3g_uarfcn_global topo_v
  ON
	bdref_visuincohtopo_vois_nokia."LCIDv" = topo_v."managedObject_WCEL"
WHERE
  topo_s."UARFCN" = topo_v."UARFCN" AND		--le uarfcns = uarfcnv
  topo_v."UARFCN" != '' AND topo_v."UARFCN" IS NOT NULL --Au cas où le EXUCE n'aurait pas de freq rempli

UNION --on trouve les ADJI:

SELECT 
  bdref_visuincohtopo_vois_nokia."LCIDs", 
  bdref_visuincohtopo_vois_nokia."NOMs", 
  topo_s."UARFCN", 
  bdref_visuincohtopo_vois_nokia."LCIDv", 
  bdref_visuincohtopo_vois_nokia."NOMv",
  topo_v."UARFCN", 
  'ADJI'::text AS object_type
FROM 
  public.bdref_visuincohtopo_vois_nokia INNER JOIN public.tmp_topologie3g_uarfcn_global topo_s
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = topo_s."managedObject_WCEL"
  INNER JOIN public.tmp_topologie3g_uarfcn_global topo_v
  ON
	bdref_visuincohtopo_vois_nokia."LCIDv" = topo_v."managedObject_WCEL"
WHERE
  topo_s."UARFCN" != topo_v."UARFCN" AND		--le uarfcns != uarfcnv
  topo_v."UARFCN" != '' AND topo_v."UARFCN" IS NOT NULL --Au cas où le EXUCE n'aurait pas de freq rempli
;

--ANALYZE car exécution lente en java:
ANALYZE t_adjs_adji_discernement;

--Ajout du ranking des voisines à rajouter :
DROP TABLE IF EXISTS t_adjs_adji_discernement_ranked;
CREATE TABLE t_adjs_adji_discernement_ranked AS
SELECT 
  t_adjs_adji_discernement.*,
  ROW_NUMBER() OVER (PARTITION BY "LCIDs",object_type ORDER BY "NOMv" ASC) AS adjs_adji_ranking
FROM 
  public.t_adjs_adji_discernement;

--Ajout du ADJ id des voisines à rajouter :
DROP TABLE IF EXISTS t_adjs_adji_discernement_adjid;
CREATE TABLE t_adjs_adji_discernement_adjid AS
SELECT 
  t_adjs_adji_discernement_ranked."LCIDs", 
  t_adjs_adji_discernement_ranked."NOMs", 
  t_adjs_adji_servingcell_available_ranked."WCEL_managedObject_distName", 
  t_adjs_adji_servingcell_available_ranked."managedObject_version",
  t_adjs_adji_discernement_ranked."UARFCN", 
  t_adjs_adji_discernement_ranked."LCIDv", 
  t_adjs_adji_discernement_ranked."NOMv", 
  --t_adjs_adji_discernement_ranked.parametre, 
  --t_adjs_adji_discernement_ranked.valeur, 
  t_adjs_adji_discernement_ranked.object_type, 
  t_adjs_adji_servingcell_available_ranked.adjs_adji_list
FROM 
  public.t_adjs_adji_discernement_ranked, 
  public.t_adjs_adji_servingcell_available_ranked
WHERE 
  t_adjs_adji_discernement_ranked."LCIDs" = t_adjs_adji_servingcell_available_ranked."LCID" AND
  t_adjs_adji_discernement_ranked.object_type = t_adjs_adji_servingcell_available_ranked.object_type AND
  t_adjs_adji_discernement_ranked.adjs_adji_ranking = t_adjs_adji_servingcell_available_ranked.adjs_adji_ranking
ORDER BY 
  t_adjs_adji_discernement_ranked."NOMs",
  t_adjs_adji_discernement_ranked.object_type DESC,
  t_adjs_adji_discernement_ranked."NOMv";

--ANALYZE car exécution lente en java:
ANALYZE t_adjs_adji_discernement_adjid;

--Crée la table des paramètres avec toutes les données:
DROP TABLE IF EXISTS t_adjs_adji_generic_create;
CREATE TABLE t_adjs_adji_generic_create AS
--ADJS:
SELECT 
  bdref_visuincohtopo_vois_nokia."NIDTs", 
  bdref_visuincohtopo_vois_nokia."NOEUDs", 
  bdref_visuincohtopo_vois_nokia."LCIDs", 
  bdref_visuincohtopo_vois_nokia."NOMs",
  t_discern."WCEL_managedObject_distName",
  t_discern."managedObject_version",
  bdref_visuincohtopo_vois_nokia."NIDTv", 
  bdref_visuincohtopo_vois_nokia."NOEUDv", 
  bdref_visuincohtopo_vois_nokia."LCIDv", 
  bdref_visuincohtopo_vois_nokia."NOMv", 
  bdref_visuincohtopo_vois_nokia."CLASSEs", 
  bdref_visuincohtopo_vois_nokia."CLASSEv", 
  bdref_visuincohtopo_vois_nokia."Etats", 
  bdref_visuincohtopo_vois_nokia."Etatv", 
  bdref_t_param_vois_def.nom_champ_vois, 
  t_adjs_adji_parameters.str_valeur,
  t_discern.object_type,
  t_discern.adjs_adji_list
FROM 
  public.t_adjs_adji_parameters INNER JOIN public.bdref_visuincohtopo_vois_nokia
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = t_adjs_adji_parameters."LCIDs" AND
	bdref_visuincohtopo_vois_nokia."LCIDv" = t_adjs_adji_parameters."LCIDv"
  INNER JOIN public.bdref_t_param_vois_def
  ON
	t_adjs_adji_parameters.idx_param_vois = bdref_t_param_vois_def.idx_param_vois
  INNER JOIN t_adjs_adji_discernement_adjid AS t_discern
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = t_discern."LCIDs" AND
	bdref_visuincohtopo_vois_nokia."LCIDv" = t_discern."LCIDv"
  WHERE 
	object_type = 'ADJS' AND
	bdref_t_param_vois_def.str_file = 'ADJS'

UNION
--ADJI:
SELECT 
  bdref_visuincohtopo_vois_nokia."NIDTs", 
  bdref_visuincohtopo_vois_nokia."NOEUDs", 
  bdref_visuincohtopo_vois_nokia."LCIDs", 
  bdref_visuincohtopo_vois_nokia."NOMs",
  t_discern."WCEL_managedObject_distName",
  t_discern."managedObject_version", 
  bdref_visuincohtopo_vois_nokia."NIDTv", 
  bdref_visuincohtopo_vois_nokia."NOEUDv", 
  bdref_visuincohtopo_vois_nokia."LCIDv", 
  bdref_visuincohtopo_vois_nokia."NOMv", 
  bdref_visuincohtopo_vois_nokia."CLASSEs", 
  bdref_visuincohtopo_vois_nokia."CLASSEv", 
  bdref_visuincohtopo_vois_nokia."Etats", 
  bdref_visuincohtopo_vois_nokia."Etatv", 
  bdref_t_param_vois_def.nom_champ_vois, 
  t_adjs_adji_parameters.str_valeur,
  t_discern.object_type,
  t_discern.adjs_adji_list
FROM 
  public.t_adjs_adji_parameters INNER JOIN public.bdref_visuincohtopo_vois_nokia
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = t_adjs_adji_parameters."LCIDs" AND
	bdref_visuincohtopo_vois_nokia."LCIDv" = t_adjs_adji_parameters."LCIDv"
  INNER JOIN public.bdref_t_param_vois_def
  ON
	t_adjs_adji_parameters.idx_param_vois = bdref_t_param_vois_def.idx_param_vois
  INNER JOIN t_adjs_adji_discernement_adjid AS t_discern
  ON
	bdref_visuincohtopo_vois_nokia."LCIDs" = t_discern."LCIDs" AND
	bdref_visuincohtopo_vois_nokia."LCIDv" = t_discern."LCIDv"
  WHERE 
	object_type = 'ADJI' AND
	bdref_t_param_vois_def.str_file = 'ADJI'

;

--Update des MNC=1 au lieu de 01
UPDATE t_adjs_adji_generic_create
SET
  str_valeur = right('00'::text || str_valeur,2)
where 
  nom_champ_vois ILIKE '%MNC%' AND
  length(str_valeur)=1;


/*
--nettoyage final:
DROP TABLE IF EXISTS t_adjs_adji_parameters;
DROP TABLE IF EXISTS t_adjs_adji_discernement;
DROP TABLE IF EXISTS t_adjs_adji_discernement_ranked;
DROP TABLE IF EXISTS t_adjs_adji_discernement_adjid;
*/

