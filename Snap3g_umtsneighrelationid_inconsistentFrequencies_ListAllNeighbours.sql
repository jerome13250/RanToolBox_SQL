DROP TABLE IF EXISTS tmp_umtsneighrelationid_count_freqs_freqv;
CREATE TABLE tmp_umtsneighrelationid_count_freqs_freqv AS
SELECT 
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.dlfrequencynumber_v,
  COUNT(t_voisines3g3g.umtsneighrelationid) AS NB
FROM 
  public.t_voisines3g3g
WHERE
  rnc != 'BACKUP_A' 
  AND umtsneighrelationid NOT LIKE 'STD\_RanSharing%'
  AND umtsneighrelationid NOT LIKE 'OPT%'
GROUP BY
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.dlfrequencynumber_v
ORDER BY
  t_voisines3g3g.umtsneighrelationid ASC,
  NB DESC;

--Crée une table avec le max number de umtsneighrelationid:
DROP TABLE IF EXISTS tmp_umtsneighrelationid_count_freqs_freqv_max;
CREATE TABLE tmp_umtsneighrelationid_count_freqs_freqv_max AS
SELECT 
  tmp_umtsneighrelationid_count_freqs_freqv.umtsneighrelationid, 
  MAX(tmp_umtsneighrelationid_count_freqs_freqv.nb) AS nb
FROM 
  public.tmp_umtsneighrelationid_count_freqs_freqv
GROUP BY
  tmp_umtsneighrelationid_count_freqs_freqv.umtsneighrelationid;

--Liste les configurations umtsneighrelationid freqs-freqv INvalides car PAS les les plus nombreuses:
DROP TABLE IF EXISTS tmp_umtsneighrelationid_count_freqs_freqv_invalide;
CREATE TABLE tmp_umtsneighrelationid_count_freqs_freqv_invalide AS

SELECT 
tmp_umtsneighrelationid_count_freqs_freqv.umtsneighrelationid, 
tmp_umtsneighrelationid_count_freqs_freqv.dlfrequencynumber_s, 
tmp_umtsneighrelationid_count_freqs_freqv.dlfrequencynumber_v,
tmp_umtsneighrelationid_count_freqs_freqv.nb
FROM 
tmp_umtsneighrelationid_count_freqs_freqv LEFT JOIN tmp_umtsneighrelationid_count_freqs_freqv_max

ON
  tmp_umtsneighrelationid_count_freqs_freqv.umtsneighrelationid = tmp_umtsneighrelationid_count_freqs_freqv_max.umtsneighrelationid AND
  tmp_umtsneighrelationid_count_freqs_freqv.nb = tmp_umtsneighrelationid_count_freqs_freqv_max.nb
WHERE
  tmp_umtsneighrelationid_count_freqs_freqv_max.nb IS NULL
;

