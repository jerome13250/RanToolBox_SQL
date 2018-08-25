SELECT 
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.dlfrequencynumber_v,
  COUNT(t_voisines3g3g.umtsneighrelationid) AS NB
FROM 
  public.t_voisines3g3g
WHERE
  rnc != 'BACKUP_A' 
  --AND umtsneighrelationid NOT LIKE 'STD\_RanSharing%'
GROUP BY
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.dlfrequencynumber_v
ORDER BY
  t_voisines3g3g.umtsneighrelationid ASC,
  NB DESC;
