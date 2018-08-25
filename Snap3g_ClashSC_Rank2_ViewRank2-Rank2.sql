SELECT 
  ranktwo1.rnc, 
  ranktwo1.fddcell,
  ranktwo1.clashintrafreq, 
  ranktwo1.dlfrequencynumber_s, 
  ranktwo1.localcellid_s, 
  ranktwo1.primaryscramblingcode_s, 
  ranktwo1.locationareacode_s, 
  ranktwo1.umtsfddneighbouringcell_rank2, 
  ranktwo1.dlfrequencynumber_v_rank2, 
  ranktwo1.localcellid_v_rank2, 
  ranktwo1.primaryscramblingcode_v_rank2, 
  ranktwo1.locationareacode_v_rank2, 
  ranktwo2.umtsfddneighbouringcell_rank2, 
  ranktwo2.dlfrequencynumber_v_rank2, 
  ranktwo2.localcellid_v_rank2, 
  ranktwo2.primaryscramblingcode_v_rank2, 
  ranktwo2.locationareacode_v_rank2
FROM 
  t_voisines3g3g_rank2 AS ranktwo1 INNER JOIN public.t_voisines3g3g_rank2 ranktwo2
   ON
     ranktwo1.fddcell = ranktwo2.fddcell
WHERE
   ranktwo1.primaryscramblingcode_v_rank2 = ranktwo2.primaryscramblingcode_v_rank2 AND
   ranktwo1.dlfrequencynumber_s = ranktwo1.dlfrequencynumber_v_rank2 AND
   ranktwo1.dlfrequencynumber_v_rank2 = ranktwo2.dlfrequencynumber_v_rank2 
   AND ranktwo1.umtsfddneighbouringcell_rank2 != ranktwo2.umtsfddneighbouringcell_rank2
ORDER BY
   ranktwo1.fddcell,
   ranktwo1.umtsfddneighbouringcell_rank2,
   ranktwo2.umtsfddneighbouringcell_rank2;
