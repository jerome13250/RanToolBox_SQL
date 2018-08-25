SELECT *
FROM bdref_tmp_idcell_3g
WHERE 
  bdref_tmp_idcell_3g.lcid IN 
	(SELECT 
	bdref_tmp_idcell_3g.lcid
	--COUNT(bdref_tmp_idcell_3g.lcid) AS nb_lcid
	FROM 
	public.bdref_tmp_idcell_3g
	GROUP BY
	bdref_tmp_idcell_3g.lcid
	HAVING
	COUNT(bdref_tmp_idcell_3g.lcid)>1)
ORDER BY bdref_tmp_idcell_3g.lcid
  ;
