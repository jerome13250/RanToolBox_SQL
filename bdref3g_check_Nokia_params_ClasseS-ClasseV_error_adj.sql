SELECT 
  t_paramvois_check_00.*,
  'param ADJI sur un intrafreq'::text AS commentaire
FROM 
  public.t_paramvois_check_00, 
  public.bdref_t_classe_mapping_freq AS tfreqs, 
  public.bdref_t_classe_mapping_freq AS tfreqv
WHERE
  t_paramvois_check_00.idx_classe_s = tfreqs.idx_classe AND
  t_paramvois_check_00.idx_classe_v = tfreqv.idx_classe AND
  tfreqs.freq = tfreqv.freq AND
  t_paramvois_check_00.str_file = 'ADJI'

UNION

SELECT 
  t_paramvois_check_00.*,
  'param ADJS sur un interfreq'::text AS commentaire
FROM 
  public.t_paramvois_check_00, 
  public.bdref_t_classe_mapping_freq AS tfreqs, 
  public.bdref_t_classe_mapping_freq AS tfreqv
WHERE
  t_paramvois_check_00.idx_classe_s = tfreqs.idx_classe AND
  t_paramvois_check_00.idx_classe_v = tfreqv.idx_classe AND
  tfreqs.freq != tfreqv.freq AND
  t_paramvois_check_00.str_file = 'ADJS'

;
