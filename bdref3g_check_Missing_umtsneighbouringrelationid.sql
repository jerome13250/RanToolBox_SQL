DROP TABLE IF EXISTS tmp_umtsneighbouringrelation_allrnc;
CREATE TEMP TABLE tmp_umtsneighbouringrelation_allrnc AS

SELECT DISTINCT
  snap3g_umtsneighbouringrelation.umtsneighbouringrelation,
  snap3g_rnc.rnc
FROM 
  snap3g_umtsneighbouringrelation,
  snap3g_rnc
WHERE 
  umtsneighbouringrelation NOT LIKE '%STD%' AND
  umtsneighbouringrelation NOT LIKE '%\_IR\_%' AND
  umtsneighbouringrelation != '0' AND
  snap3g_rnc.rnc != 'BACKUP_A'
;

SELECT 
  tmp_umtsneighbouringrelation_allrnc.umtsneighbouringrelation,
  tmp_umtsneighbouringrelation_allrnc.rnc
FROM 
  tmp_umtsneighbouringrelation_allrnc LEFT JOIN 
  snap3g_umtsneighbouringrelation
  ON
	snap3g_umtsneighbouringrelation.umtsneighbouringrelation = tmp_umtsneighbouringrelation_allrnc.umtsneighbouringrelation AND
	snap3g_umtsneighbouringrelation.rnc = tmp_umtsneighbouringrelation_allrnc.rnc
WHERE
  snap3g_umtsneighbouringrelation.rnc IS NULL
ORDER BY
  tmp_umtsneighbouringrelation_allrnc.rnc,
  tmp_umtsneighbouringrelation_allrnc.umtsneighbouringrelation;