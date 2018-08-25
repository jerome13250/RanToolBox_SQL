SELECT 
  bdref_t_param_vois_val.idx_classe_s, 
  classe1.str_classe, 
  classe1.freq,
  classe1.info,
  bdref_t_param_vois_val.idx_classe_v, 
  classe2.str_classe,
  classe2.freq,
  classe2.info, 
  bdref_t_param_vois_val.idx_param_vois, 
  bdref_t_param_vois_def.nom_champ_vois, 
  bdref_t_param_vois_val.idx_palier, 
  bdref_t_param_vois_val.str_valeur,
  CASE 	WHEN bdref_t_param_vois_val.idx_classe_s LIKE '2%' AND idx_palier != '-2' THEN 'pallier différent de celui par défaut'
	WHEN ( bdref_t_param_vois_val.idx_classe_s LIKE '2%' AND classe1.freq = classe2.freq AND bdref_t_param_vois_def.nom_champ_vois LIKE 'Adji%') THEN 'Param Interfreq défini pour de l intrafreq'
	WHEN ( bdref_t_param_vois_val.idx_classe_s LIKE '2%' AND classe1.freq != classe2.freq AND bdref_t_param_vois_def.nom_champ_vois LIKE 'Adjs%') THEN 'Param Intrafreq défini pour de l interfreq'

        ELSE NULL END 
	AS erreur
FROM 
  public.bdref_t_param_vois_val INNER JOIN public.bdref_t_classe classe1
  ON 
	bdref_t_param_vois_val.idx_classe_s = classe1.idx_classe
  INNER JOIN public.bdref_t_classe classe2
  ON 
	bdref_t_param_vois_val.idx_classe_v = classe2.idx_classe
  INNER JOIN public.bdref_t_param_vois_def
  ON
	bdref_t_param_vois_val.idx_param_vois = bdref_t_param_vois_def.idx_param_vois
WHERE 
   ( bdref_t_param_vois_val.idx_classe_s LIKE '2%' AND idx_palier != '-2') OR --Un pallier différent de celui par défaut est défini
   ( bdref_t_param_vois_val.idx_classe_s LIKE '2%' AND classe1.freq = classe2.freq AND bdref_t_param_vois_def.nom_champ_vois LIKE 'Adji%') OR --Un pallier différent de celui par défaut est défini
   ( bdref_t_param_vois_val.idx_classe_s LIKE '2%' AND classe1.freq != classe2.freq AND bdref_t_param_vois_def.nom_champ_vois LIKE 'Adjs%') 
  
ORDER BY
  idx_classe_s,
  idx_classe_v;
