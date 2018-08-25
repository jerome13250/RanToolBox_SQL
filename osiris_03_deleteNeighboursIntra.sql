SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.rncid_s, 
  t_voisines3g3g.fddcell,
  t_topologie3g.codenidt,
  t_topologie3g.administrativestate AS administrativestate_s,
  t_topologie3g.operationalstate AS operationalstate_s,
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.localcellid_s AS LCIDS, 
  t_voisines3g3g.primaryscramblingcode_s, 
  t_voisines3g3g.locationareacode_s, 
  t_voisines3g3g.rnc_v, 
  t_voisines3g3g.rncid_v, 
  t_voisines3g3g.umtsfddneighbouringcell,
  topo2.administrativestate AS administrativestate_v,
  topo2.operationalstate AS operationalstate_v,
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.localcellid_v AS LCIDV, 
  t_voisines3g3g.primaryscramblingcode_v, 
  t_voisines3g3g.locationareacode_v, 
  ranknote,
  'S' AS OPERATION,
  row_number
FROM 
  public.t_voisines3g3g LEFT JOIN public.osiris_fluxctn3g3g_intrafreq
  ON 
    t_voisines3g3g.localcellid_s = osiris_fluxctn3g3g_intrafreq."LCID_S" AND
    t_voisines3g3g.localcellid_v = osiris_fluxctn3g3g_intrafreq."LCID_V"
    
  LEFT JOIN public.t_topologie3g
  ON 
    t_voisines3g3g.fddcell = t_topologie3g.fddcell
    
  LEFT JOIN public.t_topologie3g AS topo2
  ON 
    t_voisines3g3g.umtsfddneighbouringcell = topo2.fddcell	
	
	
  
WHERE 
  t_voisines3g3g.dlfrequencynumber_s = t_voisines3g3g.dlfrequencynumber_v -- INTRAFREQ seulement
  AND t_voisines3g3g.dlfrequencynumber_s IN ('10787','3011') -- Les CTN ne sont representatifs que sur le CS donc FDD10 et UMTS900
  AND ( row_number > 31 --Supprime les voisines superieures a 31
	      OR osiris_fluxctn3g3g_intrafreq."LCID_S" IS NULL )--La voisine ne fait pas partie de notre plan simule
  AND t_topologie3g.operationalstate = 'enabled'  -- Les sites offline sont exclus
  AND t_voisines3g3g.localcellid_s IN (SELECT DISTINCT "LCID_S" FROM osiris_fluxctn3g3g_intrafreq )
ORDER BY
  t_voisines3g3g.fddcell,
  t_voisines3g3g.umtsfddneighbouringcell
;
