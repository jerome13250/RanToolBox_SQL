--Creation d'une table avec les donnees utiles, manque la RAC, à voir plus tard...
DROP TABLE IF EXISTS t_vois_cible_bdref_umtsneighrelationid;
CREATE TABLE t_vois_cible_bdref_umtsneighrelationid AS

SELECT 
  bdref_t_param_vois_cible_umtsneighrelationid."LCID_s",
  topo1."LCID" AS "vrai_lcid_s",
  topo1."LAC" AS "LAC_s", 
  bdref_t_param_vois_cible_umtsneighrelationid."LCID_v", 
  topo2."LCID" AS "vrai_lcid_v",
  topo2."LAC" AS "LAC_v",
  --Pas obligatoire d'enlever UmtsNeighbouring/0 UmtsNeighbouringRelation/ mais je l'ai fait dans mes tables :
  replace(bdref_t_param_vois_cible_umtsneighrelationid.str_valeur,'UmtsNeighbouring/0 UmtsNeighbouringRelation/','') AS "umtsNeighRelationid"
FROM 
  public.bdref_t_param_vois_cible_umtsneighrelationid, 
  public.bdref_t_topologie topo1, 
  public.bdref_t_topologie topo2
WHERE 
  bdref_t_param_vois_cible_umtsneighrelationid."LCID_s" = topo1.bdref_idcell AND
  bdref_t_param_vois_cible_umtsneighrelationid."LCID_v" = topo2.bdref_idcell;




