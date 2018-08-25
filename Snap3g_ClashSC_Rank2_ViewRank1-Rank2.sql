SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.fddcell,
  t_voisines3g3g_rank2.clashintrafreq, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.primaryscramblingcode_s, 
  t_voisines3g3g.locationareacode_s, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.localcellid_v, 
  t_voisines3g3g.primaryscramblingcode_v, 
  t_voisines3g3g.locationareacode_v, 
  t_voisines3g3g_rank2.umtsfddneighbouringcell_rank2, 
  t_voisines3g3g_rank2.dlfrequencynumber_v_rank2, 
  t_voisines3g3g_rank2.localcellid_v_rank2, 
  t_voisines3g3g_rank2.primaryscramblingcode_v_rank2, 
  t_voisines3g3g_rank2.locationareacode_v_rank2
FROM 
  public.t_voisines3g3g INNER JOIN public.t_voisines3g3g_rank2
   ON
     t_voisines3g3g.fddcell = t_voisines3g3g_rank2.fddcell
WHERE
   t_voisines3g3g.primaryscramblingcode_v = t_voisines3g3g_rank2.primaryscramblingcode_v_rank2 AND
   t_voisines3g3g.dlfrequencynumber_s = t_voisines3g3g.dlfrequencynumber_v AND
   t_voisines3g3g.dlfrequencynumber_v = t_voisines3g3g_rank2.dlfrequencynumber_v_rank2 
   AND t_voisines3g3g.umtsfddneighbouringcell != t_voisines3g3g_rank2.umtsfddneighbouringcell_rank2
ORDER BY
   t_voisines3g3g.fddcell,
   t_voisines3g3g.umtsfddneighbouringcell

;
