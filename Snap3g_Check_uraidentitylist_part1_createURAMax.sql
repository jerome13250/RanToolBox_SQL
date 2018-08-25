DROP TABLE IF EXISTS t_tmp_uraidentitylist_count;
CREATE TABLE t_tmp_uraidentitylist_count AS

SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.uraidentitylist,
  count(t_topologie3g.uraidentitylist) AS ura_number
FROM 
  public.t_topologie3g
GROUP BY 
  t_topologie3g.rnc, 
  t_topologie3g.uraidentitylist
ORDER BY
  t_topologie3g.rnc;


DROP TABLE IF EXISTS t_tmp_uraidentitylist_max;
CREATE TABLE t_tmp_uraidentitylist_max AS

SELECT 
  t_tmp_uraidentitylist_count.rnc, 
  MAX(t_tmp_uraidentitylist_count.ura_number)
FROM 
  public.t_tmp_uraidentitylist_count
GROUP BY
  t_tmp_uraidentitylist_count.rnc;

DROP TABLE IF EXISTS t_uraidentitylist_max_final;
CREATE TABLE t_uraidentitylist_max_final AS

SELECT 
  t_tmp_uraidentitylist_count.rnc, 
  t_tmp_uraidentitylist_count.uraidentitylist, 
  t_tmp_uraidentitylist_count.ura_number
FROM 
  public.t_tmp_uraidentitylist_count, 
  public.t_tmp_uraidentitylist_max
WHERE 
  t_tmp_uraidentitylist_count.rnc = t_tmp_uraidentitylist_max.rnc AND
  t_tmp_uraidentitylist_count.ura_number = t_tmp_uraidentitylist_max.max;

DROP TABLE IF EXISTS t_tmp_uraidentitylist_count;
DROP TABLE IF EXISTS t_tmp_uraidentitylist_max;
