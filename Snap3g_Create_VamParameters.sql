SELECT 
  t_topologie3g.rnc,
  snap3g_btscell.btsequipment, 
  snap3g_btscell.btscell, 
  t_topologie3g.fddcell,
  t_topologie3g.dlfrequencynumber, 
  snap3g_vamparameters.vamparameters, 
  snap3g_vamparameters.vamamplitudecoeff, 
  snap3g_vamparameters.vamphasecoeff
FROM 
  public.snap3g_btscell LEFT JOIN public.snap3g_vamparameters
  ON 
  snap3g_vamparameters.btsequipment = snap3g_btscell.btsequipment AND
  snap3g_vamparameters.btscell = snap3g_btscell.btscell
  INNER JOIN public.t_topologie3g
  ON
  snap3g_btscell.associatedfddcell = t_topologie3g.fddcell

WHERE 
 snap3g_btscell.btsequipment NOT IN ( --Liste toutes les bts qui portent une FDD7 donc quadrifreq
	SELECT DISTINCT
	snap3g_btscell.btsequipment
	FROM 
	public.snap3g_btscell, 
	public.t_topologie3g
	WHERE 
	snap3g_btscell.associatedfddcell = t_topologie3g.fddcell AND
	t_topologie3g.dlfrequencynumber = '10712')

  AND t_topologie3g.dlfrequencynumber IN ('10787','10812','10836')

ORDER BY
  snap3g_btscell.btsequipment ASC, 
  t_topologie3g.fddcell ASC

;
