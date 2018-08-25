SELECT *
FROM public.t_topologie3g
WHERE t_topologie3g.localcellid IN 
	(SELECT 
	t_topologie3g.localcellid
	FROM 
	public.t_topologie3g
	GROUP BY 
	t_topologie3g.localcellid
	HAVING 
	COUNT(t_topologie3g.localcellid)>1)
ORDER BY  t_topologie3g.localcellid;
