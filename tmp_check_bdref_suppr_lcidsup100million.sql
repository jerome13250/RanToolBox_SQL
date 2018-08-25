DROP TABLE IF EXISTS tmp_bdref_lcid_sup100millions_step2;
CREATE TABLE tmp_bdref_lcid_sup100millions_step2 AS

SELECT 
  tmp_bdref_lcid_sup100millions."ADJ",
  "nokia_ADJI"."AdjiMNC" AS "MNC_v", 
  "nokia_ADJI"."AdjiMNC" AS "MNC_v", 
  "nokia_ADJI"."AdjiMCC" AS "MCC_v",
  "nokia_ADJI"."AdjiRNCid" AS "RNCid_v", 
  "nokia_ADJI"."AdjiCI" AS "CI_v"
FROM 
  public.tmp_bdref_lcid_sup100millions, 
  public."nokia_ADJI"
WHERE 
  tmp_bdref_lcid_sup100millions."ADJ" = "nokia_ADJI"."managedObject_distName"

UNION

SELECT 
  tmp_bdref_lcid_sup100millions."ADJ", 
  "nokia_ADJS"."AdjsMNC" AS "MNC_v", 
  "nokia_ADJS"."AdjsMCC" AS "MCC_v", 
  "nokia_ADJS"."AdjsRNCid" AS "RNCid_v", 
  "nokia_ADJS"."AdjsCI" AS "CI_v"
FROM 
  public.tmp_bdref_lcid_sup100millions, 
  public."nokia_ADJS"
WHERE 
  tmp_bdref_lcid_sup100millions."ADJ" = "nokia_ADJS"."managedObject_distName";



SELECT
  tmp_bdref_lcid_sup100millions_step2."ADJ", 
  tmp_bdref_lcid_sup100millions_step2."MNC_v", 
  tmp_bdref_lcid_sup100millions_step2."MCC_v", 
  tmp_bdref_lcid_sup100millions_step2."RNCid_v", 
  tmp_bdref_lcid_sup100millions_step2."CI_v", 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.runningsoftwareversion, 
  t_topologie3g.fddcell
FROM 
  public.tmp_bdref_lcid_sup100millions_step2 LEFT JOIN public.t_topologie3g
  ON 
	  tmp_bdref_lcid_sup100millions_step2."MNC_v" = t_topologie3g.mobilenetworkcode AND
	  tmp_bdref_lcid_sup100millions_step2."MCC_v" = t_topologie3g.mobilecountrycode AND
	  tmp_bdref_lcid_sup100millions_step2."RNCid_v" = t_topologie3g.rncid AND
	  tmp_bdref_lcid_sup100millions_step2."CI_v" = t_topologie3g.cellid
  LEFT JOIN public.snap3g_rnc ON
	tmp_bdref_lcid_sup100millions_step2."RNCid_v" = snap3g_rnc.rncid
ORDER BY
  tmp_bdref_lcid_sup100millions_step2."RNCid_v", 
  tmp_bdref_lcid_sup100millions_step2."CI_v";