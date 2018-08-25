SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.rncid_s, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.primaryscramblingcode_s, 
  t_voisines3g3g.rnc_v, 
  t_voisines3g3g.rncid_v, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.primaryscramblingcode_v
FROM 
  public.t_voisines3g3g LEFT JOIN public.snap3g_neighbouringrnc
  ON
  t_voisines3g3g.rnc = snap3g_neighbouringrnc.rnc AND
  t_voisines3g3g.rncid_v = snap3g_neighbouringrnc.neighbouringrnc
WHERE 
   snap3g_neighbouringrnc.neighbouringrnc IS NULL 
   AND t_voisines3g3g.rncid_s != t_voisines3g3g.rncid_v --Voisinages intra RNC
   AND t_voisines3g3g.umtsfddneighbouringcell NOT LIKE 'SuperCell%' --Enleve les Femto
   AND dlfrequencynumber_s NOT IN ('2950','3075','10639') --Enleve les cellules sources Ran sharing BYT et SFR
   AND umtsfddneighbouringcell NOT LIKE 'CELL_RS%' --Enleve les cibles Ran Sharing

ORDER BY
  t_voisines3g3g.rnc ASC, 
  t_voisines3g3g.rnc_v ASC,
  t_voisines3g3g.fddcell ASC, 
  t_voisines3g3g.umtsfddneighbouringcell
;
