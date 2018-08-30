--Requete affichant les parametrage Classes-ClasseV par defaut dans BDREF pour Nokia

SELECT 
  bdref_t_classe_s.str_classe AS str_classe_s, 
  bdref_t_classe_v.str_classe  AS str_classe_v,
  bdref_t_param_vois_def.nom_champ_vois,  
  --bdref_t_param_vois_val.idx_palier, 
  bdref_t_param_vois_val.str_valeur
FROM 
  public.bdref_t_param_vois_val INNER JOIN public.bdref_t_param_vois_def
  ON
     bdref_t_param_vois_val.idx_param_vois = bdref_t_param_vois_def.idx_param_vois
  INNER JOIN public.bdref_t_classe bdref_t_classe_s
  ON
    bdref_t_param_vois_val.idx_classe_s = bdref_t_classe_s.idx_classe
  INNER JOIN public.bdref_t_classe bdref_t_classe_v
  ON
    bdref_t_param_vois_val.idx_classe_v = bdref_t_classe_v.idx_classe
WHERE 
   bdref_t_classe_s.str_classe LIKE 'Nokia%' 
   AND bdref_t_param_vois_def.nom_champ_vois = 'RtHopiIdentifier'

ORDER BY
  bdref_t_classe_s.str_classe, 
  bdref_t_classe_v.str_classe,
  bdref_t_param_vois_def.nom_champ_vois 
  --bdref_t_param_vois_val.idx_palier
  ;
