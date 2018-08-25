--Creation d'une table plus petite contenant uniquement les données umtsneighrelationid
DROP TABLE IF EXISTS bdref_t_param_vois_cible_umtsneighrelationid;
CREATE TABLE bdref_t_param_vois_cible_umtsneighrelationid AS

SELECT 
  bdref_t_param_vois_cible."LCID_s", 
  bdref_t_param_vois_cible."LCID_v", 
  bdref_t_param_vois_cible.idx_param_vois, 
  bdref_t_param_vois_cible.str_valeur
FROM 
  public.bdref_t_param_vois_cible
WHERE idx_param_vois = '40000044';

