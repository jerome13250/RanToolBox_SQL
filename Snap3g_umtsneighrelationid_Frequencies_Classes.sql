SELECT 
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s,
  classe1."CLASSE" AS classe_s,
  t_voisines3g3g.dlfrequencynumber_v,
  classe2."CLASSE" AS classe_v,
  COUNT(t_voisines3g3g.umtsneighrelationid) AS NB
FROM 
  public.t_voisines3g3g LEFT JOIN bdref_visutopoomc_classe_france AS classe1
	ON t_voisines3g3g.localcellid_s = classe1."LCID"
  LEFT JOIN bdref_visutopoomc_classe_france AS classe2
	ON t_voisines3g3g.localcellid_v = classe2."LCID"
  
GROUP BY
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s,
  classe1."CLASSE", 
  t_voisines3g3g.dlfrequencynumber_v,
  classe2."CLASSE"
ORDER BY
  t_voisines3g3g.umtsneighrelationid ASC,
  NB DESC;
