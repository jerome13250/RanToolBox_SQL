--Compte le nombre de freq 2100 fdd10-11-12-7 sur chaque nodeb
DROP TABLE IF EXISTS tmp_nodeb_nbfreq2100orange;

CREATE TABLE tmp_nodeb_nbfreq2100orange AS
SELECT 
  rnc,
  nodeb,
  COUNT(nodeb) AS nbfreq2100orange
FROM (
	SELECT DISTINCT
	snap3g_fddcell.rnc, 
	snap3g_fddcell.nodeb,
	snap3g_fddcell.dlfrequencynumber
	FROM 
	  public.snap3g_fddcell
	WHERE
	dlfrequencynumber IN ('10787','10812','10836','10712') AND
	nodeb NOT LIKE ''
	) AS t1

GROUP BY
  rnc, 
  nodeb
ORDER BY
  rnc, 
  nodeb;

