--Sort toutes les relations de voisinages avec freqs-freqv invalide :
SELECT 
  vois.fddcell,
  vois.classe_s, 
  vois.dlfrequencynumber_s, 
  vois.localcellid_s, 
  vois.umtsfddneighbouringcell,
  vois.classe_v, 
  vois.dlfrequencynumber_v, 
  vois.localcellid_v, 
  vois.umtsneighrelationid
FROM 
   public.t_voisines3g3g_bdref AS vois INNER JOIN public.tmp_umtsneighrelationid_count_freqs_freqv_invalide AS invalide
  ON  
	  invalide.umtsneighrelationid = vois.umtsneighrelationid AND
	  invalide.dlfrequencynumber_s = vois.dlfrequencynumber_s AND
	  invalide.dlfrequencynumber_v = vois.dlfrequencynumber_v
ORDER BY
fddcell, 
umtsfddneighbouringcell
;
