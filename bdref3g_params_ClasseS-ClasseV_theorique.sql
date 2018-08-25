--Crée la liste des params theoriques obligatoires :
DROP TABLE IF EXISTS t_paramvois_theorique;
CREATE TABLE t_paramvois_theorique AS
SELECT 
  tmap_s.idx_classe AS idx_classe_s, 
  tmap_s.str_classe AS str_classe_s,
  tmap_s.freq AS freq_s,  
  tmap_v.idx_classe AS idx_classe_v, 
  tmap_v.str_classe AS str_classe_v, 
  tmap_v.freq AS freq_v,
  bdref_t_param_vois_obligatoires.*
FROM 
  public.bdref_t_classe_mapping_freq AS tmap_s, 
  public.bdref_t_classe_mapping_freq AS tmap_v,
  public.bdref_t_param_vois_obligatoires
WHERE
  tmap_s.str_classe ILIKE 'Nokia%' AND
  tmap_v.freq != '' AND --Exclue les classes voisines inconnues ou obsolètes
  tmap_s.freq != tmap_v.freq AND --Objet ADJI interfreq
  bdref_t_param_vois_obligatoires.object_type = 'ADJI' AND
  (     --cas intra-Orange:
	( tmap_s.str_classe NOT ILIKE '%BYT%' AND tmap_v.str_classe NOT ILIKE '%BYT%' AND
	tmap_s.str_classe NOT ILIKE '%SFR%' AND tmap_v.str_classe NOT ILIKE '%SFR%' AND
	tmap_s.str_classe NOT ILIKE '%FRM%' AND tmap_v.str_classe NOT ILIKE '%FRM%'
	)
	OR --cas autres opérateurs:
	( (tmap_s.str_classe ILIKE '%BYT%' AND tmap_v.str_classe ILIKE '%BYT%') OR
	  (tmap_s.str_classe ILIKE '%SFR%' AND tmap_v.str_classe ILIKE '%SFR%') OR
	  (tmap_s.str_classe ILIKE '%FRM%' AND tmap_v.str_classe ILIKE '%FRM%')
	)
  )
  

UNION

SELECT 
  tmap_s.idx_classe AS idx_classe_s, 
  tmap_s.str_classe AS str_classe_s,
  tmap_s.freq AS freq_s,  
  tmap_v.idx_classe AS idx_classe_v, 
  tmap_v.str_classe AS str_classe_v, 
  tmap_v.freq AS freq_v,
  bdref_t_param_vois_obligatoires.*
FROM 
  public.bdref_t_classe_mapping_freq AS tmap_s, 
  public.bdref_t_classe_mapping_freq AS tmap_v,
  public.bdref_t_param_vois_obligatoires
WHERE
  tmap_s.str_classe ILIKE 'Nokia%' AND
  tmap_v.freq != '' AND --Exclue les classes voisines inconnues ou obsolètes
  tmap_s.freq = tmap_v.freq AND--Objet ADJI interfreq
  bdref_t_param_vois_obligatoires.object_type = 'ADJS' AND
  (     --cas intra-Orange:
	( tmap_s.str_classe NOT ILIKE '%BYT%' AND tmap_v.str_classe NOT ILIKE '%BYT%' AND
	tmap_s.str_classe NOT ILIKE '%SFR%' AND tmap_v.str_classe NOT ILIKE '%SFR%' AND
	tmap_s.str_classe NOT ILIKE '%FRM%' AND tmap_v.str_classe NOT ILIKE '%FRM%'
	)
	OR --cas autres opérateurs:
	( (tmap_s.str_classe ILIKE '%BYT%' AND tmap_v.str_classe ILIKE '%BYT%') OR
	  (tmap_s.str_classe ILIKE '%SFR%' AND tmap_v.str_classe ILIKE '%SFR%') OR
	  (tmap_s.str_classe ILIKE '%FRM%' AND tmap_v.str_classe ILIKE '%FRM%')
	)
  )

ORDER BY
  str_classe_s,
  str_classe_v,
  param_name
  ;
