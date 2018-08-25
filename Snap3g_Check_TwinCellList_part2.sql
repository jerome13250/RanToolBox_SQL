SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.provisionedsystemrelease, 
  snap3g_rnc.clusterid, 
  t_topologie3g.nodeb,
  t_twincelllist_theorique.fddcell, 
  '<value>' || string_agg(t_twincelllist_theorique.cellidv,'</value><value>') || '</value>' as "twinCellList"
FROM 
  public.t_twincelllist_theorique INNER JOIN public.t_topologie3g
  ON
	t_twincelllist_theorique.fddcell = t_topologie3g.fddcell
  INNER JOIN public.snap3g_rnc
  ON
	t_topologie3g.rnc = snap3g_rnc.rnc
WHERE 
  t_twincelllist_theorique.fddcell IN 
  (
  SELECT DISTINCT 
	t_twincelllist_errors.fddcell
	FROM t_twincelllist_errors
  )

GROUP BY 
  t_topologie3g.rnc, 
  t_topologie3g.provisionedsystemrelease, 
  snap3g_rnc.clusterid, 
  t_topologie3g.nodeb,
  t_twincelllist_theorique.fddcell
  
ORDER BY
  t_topologie3g.rnc ASC,
  t_twincelllist_theorique.fddcell ASC;
