SELECT 
  t_topologie4g.ltecell, 
  t_topologie4g.eci, 
  t_topologie4g.dlearfcn, 
  t_topologie4g.trackingareacode, 
  t_topologie4g_2.ltecell, 
  t_topologie4g_2.eci, 
  t_topologie4g_2.dlearfcn, 
  t_topologie4g_2.trackingareacode
FROM 
  public.t_topologie4g INNER JOIN public.t_topologie4g t_topologie4g_2
	ON 
	t_topologie4g.enbequipment = t_topologie4g_2.enbequipment 
WHERE
  t_topologie4g.trackingareacode != t_topologie4g_2.trackingareacode
ORDER BY
 t_topologie4g.ltecell,
 t_topologie4g_2.ltecell
;
