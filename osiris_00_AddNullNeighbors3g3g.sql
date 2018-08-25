INSERT INTO osiris_fluxctn3g3g ("RNC_S","LCID_S","LAC_S","NOM_S","BANDE_S","RNC_V","LCID_V","LAC_V","NOM_V","BANDE_V","HO_SUCC_TOTAL","HO_ATT_TOTAL","HO_DETECTED","VOIS","SIB11ANDDCH","Distance(m)")

SELECT DISTINCT
  t_voisines3g3g.rnc, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.locationareacode_s, 
  t_voisines3g3g.fddcell, 
   CASE dlfrequencynumber_s
	WHEN '3011' THEN 'UMTS900'
	WHEN '10787' THEN 'FDD10'
	WHEN '10812' THEN 'FDD11'
	WHEN '10836' THEN 'FDD12'
	WHEN '10712' THEN 'FDD7'
   END AS bande_s,
  t_voisines3g3g.rnc_v, 
  t_voisines3g3g.localcellid_v, 
  t_voisines3g3g.locationareacode_v, 
  t_voisines3g3g.umtsfddneighbouringcell, 
   CASE dlfrequencynumber_v
	WHEN '3011' THEN 'UMTS900'
	WHEN '10787' THEN 'FDD10'
	WHEN '10812' THEN 'FDD11'
	WHEN '10836' THEN 'FDD12'
	WHEN '10712' THEN 'FDD7'
   END AS bande_v, 
  '500000' AS "HO_SUCC_TOTAL",
  '500000' AS "HO_ATT_TOTAL",
  '0' AS "HO_DETECTED",
  '1' AS "VOIS", 
  CASE WHEN (t_voisines3g3g.sib11ordchusage LIKE '%sib11%') THEN '1' ELSE '0' END AS "SIB11ANDDCH",
  '0' AS "Distance(m)"

FROM 
  public.t_voisines3g3g LEFT JOIN public.osiris_fluxctn3g3g
  ON 
     t_voisines3g3g.localcellid_s = osiris_fluxctn3g3g."LCID_S"
     AND t_voisines3g3g.localcellid_v = osiris_fluxctn3g3g."LCID_V"
  LEFT JOIN public.t_topologie3g
     ON t_voisines3g3g.umtsfddneighbouringcell = t_topologie3g.fddcell
WHERE
  osiris_fluxctn3g3g."LCID_S" IS NULL
  AND t_topologie3g.operationalstate = 'disabled'
ORDER BY
  umtsfddneighbouringcell,
  fddcell
  
;
