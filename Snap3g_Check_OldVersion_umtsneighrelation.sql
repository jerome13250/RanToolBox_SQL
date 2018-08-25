SELECT 
  * 
FROM 
  public.t_voisines3g3g
WHERE 
  ((t_voisines3g3g.umtsneighrelationid LIKE 'STD%' AND 
  t_voisines3g3g.umtsneighrelationid NOT LIKE 'STD_RanSharing%')
  OR 
  t_voisines3g3g.umtsneighrelationid LIKE 'Umts%')
  --AND rnc != 'BACKUP_A'
  ;
