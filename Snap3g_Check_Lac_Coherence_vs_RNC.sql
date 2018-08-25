DROP TABLE IF EXISTS tmp_rncalu_countlac;
CREATE TABLE tmp_rncalu_countlac AS
SELECT 
  snap3g_fddcell.rnc,
  snap3g_fddcell.mobilecountrycode,
  snap3g_fddcell.mobilenetworkcode, 
  snap3g_fddcell.locationareacode,
  COUNT(snap3g_fddcell.locationareacode) AS count_lac
FROM 
  public.snap3g_fddcell
GROUP BY
  snap3g_fddcell.rnc,
  snap3g_fddcell.mobilecountrycode,
  snap3g_fddcell.mobilenetworkcode,
  snap3g_fddcell.locationareacode
ORDER BY
  rnc,
  snap3g_fddcell.mobilecountrycode,
  snap3g_fddcell.mobilenetworkcode;


DROP TABLE IF EXISTS tmp_rncalu_countlac_maxalone;
CREATE TABLE tmp_rncalu_countlac_maxalone AS
  SELECT
  rnc,
  mobilecountrycode,
  mobilenetworkcode, 
  MAX(count_lac) AS max_count_lac
FROM
  tmp_rncalu_countlac
GROUP BY
  rnc,
  mobilecountrycode,
  mobilenetworkcode;

DROP TABLE IF EXISTS tmp_rncalu_countlac_max;
CREATE TABLE tmp_rncalu_countlac_max AS
SELECT 
  tmp_rncalu_countlac.rnc, 
  tmp_rncalu_countlac.mobilecountrycode, 
  tmp_rncalu_countlac.mobilenetworkcode, 
  tmp_rncalu_countlac.locationareacode, 
  tmp_rncalu_countlac.count_lac
FROM 
  public.tmp_rncalu_countlac INNER JOIN public.tmp_rncalu_countlac_maxalone
  ON
  tmp_rncalu_countlac.rnc = tmp_rncalu_countlac_maxalone.rnc AND
  tmp_rncalu_countlac.mobilecountrycode = tmp_rncalu_countlac_maxalone.mobilecountrycode AND
  tmp_rncalu_countlac.mobilenetworkcode = tmp_rncalu_countlac_maxalone.mobilenetworkcode AND
  tmp_rncalu_countlac.count_lac = tmp_rncalu_countlac_maxalone.max_count_lac;


DROP TABLE IF EXISTS tmp_rncalu_countlac_incohs;
CREATE TABLE tmp_rncalu_countlac_incohs AS
SELECT 
  tmp_rncalu_countlac.rnc, 
  tmp_rncalu_countlac.mobilecountrycode, 
  tmp_rncalu_countlac.mobilenetworkcode, 
  tmp_rncalu_countlac.locationareacode, 
  tmp_rncalu_countlac.count_lac, 
  max2.locationareacode AS max_locationareacode, 
  max2.count_lac AS max_count_lac
FROM 
  public.tmp_rncalu_countlac LEFT JOIN public.tmp_rncalu_countlac_max max1 --on cherche les LAC qui ne font pas partie des plus nombreuses
  ON
	tmp_rncalu_countlac.rnc = max1.rnc AND
	tmp_rncalu_countlac.mobilecountrycode = max1.mobilecountrycode AND
	tmp_rncalu_countlac.mobilenetworkcode = max1.mobilenetworkcode AND
	tmp_rncalu_countlac.locationareacode = max1.locationareacode AND
	tmp_rncalu_countlac.count_lac = max1.count_lac
  INNER JOIN public.tmp_rncalu_countlac_max max2 --On trouve les LAC les plus nombreuses correspondantes à ce rnc+mcc+mnc
  ON 
	tmp_rncalu_countlac.rnc = max2.rnc AND
	tmp_rncalu_countlac.mobilecountrycode = max2.mobilecountrycode AND
	tmp_rncalu_countlac.mobilenetworkcode = max2.mobilenetworkcode
  
WHERE 
  max1.count_lac IS NULL
  
  ;
  
  
--Suppression des tables temporaires :
DROP TABLE IF EXISTS tmp_rncalu_countlac;
DROP TABLE IF EXISTS tmp_rncalu_countlac_maxalone;
DROP TABLE IF EXISTS tmp_rncalu_countlac_max;




