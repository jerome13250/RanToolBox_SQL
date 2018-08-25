SELECT 
  t_voisines3g3g_nokia_inter.* 
FROM 
  public.t_voisines3g3g_nokia_inter LEFT JOIN public.t_topologie3g
  ON
	t_voisines3g3g_nokia_inter."AdjiRNCid" = t_topologie3g.rncid AND
	t_voisines3g3g_nokia_inter."AdjiCI" = t_topologie3g.cellid
WHERE
  t_topologie3g.rncid IS NULL;