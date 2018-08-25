SELECT *
FROM public.t_topologie3g
WHERE t_topologie3g.fddcell IN 
	(SELECT 
	t_topologie3g.fddcell
	FROM 
	public.t_topologie3g
	GROUP BY 
	t_topologie3g.fddcell
	HAVING 
	COUNT(t_topologie3g.fddcell)>1)
ORDER BY  t_topologie3g.fddcell;
