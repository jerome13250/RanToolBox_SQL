SELECT 
  t_paramvois_check_00.*,
  'parametre a supprimer'::text AS commentaire
FROM 
  public.t_paramvois_check_00 LEFT JOIN public.t_paramvois_theorique
  ON
  t_paramvois_check_00.idx_classe_s = t_paramvois_theorique.idx_classe_s AND
  t_paramvois_check_00.idx_classe_v = t_paramvois_theorique.idx_classe_v AND
  t_paramvois_check_00.nom_champ_vois = t_paramvois_theorique.param_name
WHERE
  t_paramvois_theorique.idx_classe_s IS NULL AND
  idx_param_vois LIKE '2%'

ORDER BY
  str_classe_s,
  str_classe_v,
  nom_champ_vois
  ;
