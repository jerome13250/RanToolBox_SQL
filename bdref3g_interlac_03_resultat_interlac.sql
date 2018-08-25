SELECT 
  t_vois_cible_bdref_umtsneighrelationid."LCID_s" AS bdref_key_lcids, 
  t_vois_cible_bdref_umtsneighrelationid."vrai_lcid_s" AS "LCIDs",
  t_vois_cible_bdref_umtsneighrelationid."LAC_s",
  t_vois_cible_bdref_umtsneighrelationid."LCID_v" AS bdref_key_lcidv,
    t_vois_cible_bdref_umtsneighrelationid."vrai_lcid_v"  AS "LCIDv",
  t_vois_cible_bdref_umtsneighrelationid."LAC_v", 
  'umtsNeighRelationid' AS parametre,
  t_vois_cible_bdref_umtsneighrelationid."umtsNeighRelationid" AS valeur_actuelle, 
  bdref_mapping_neighbrel_interlac.neighbrel_interlac AS valeur,
  'param InterLAC' AS commentaire
FROM 
  public.t_vois_cible_bdref_umtsneighrelationid, 
  public.bdref_mapping_neighbrel_interlac
WHERE 
  t_vois_cible_bdref_umtsneighrelationid."umtsNeighRelationid" = bdref_mapping_neighbrel_interlac.neighbrel_intralac AND
  t_vois_cible_bdref_umtsneighrelationid."LAC_s" NOT LIKE t_vois_cible_bdref_umtsneighrelationid."LAC_v"
ORDER BY
  t_vois_cible_bdref_umtsneighrelationid."LCID_s",
  t_vois_cible_bdref_umtsneighrelationid."LCID_v";