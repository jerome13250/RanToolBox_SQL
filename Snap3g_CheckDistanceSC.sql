SELECT 
  t1.rnc, 
  t1.rncid, 
  t1.fddcell, 
  t1.dlfrequencynumber,
  t1.primaryscramblingcode,
  t1.locationareacode, 
  t1.localcellid,
  t1.codenidt,
  t1.administrativestate,
  t1.operationalstate,
  t2.rnc, 
  t2.rncid, 
  t2.fddcell, 
  t2.dlfrequencynumber,
  t2.primaryscramblingcode, 
  t2.locationareacode, 
  t2.localcellid,
  t2.codenidt,
  t2.administrativestate,
  t2.operationalstate,
  round(cast(|/((to_number(t1.longitude, '999999999')-to_number(t2.longitude, '999999999')) ^ 2 
	+ (to_number(t1.latitude, '999999999')-to_number(t2.latitude, '999999999')) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_topologie3g AS t1 INNER JOIN public.t_topologie3g AS t2 
ON 
  (t1.primaryscramblingcode = t2.primaryscramblingcode AND
  t1.dlfrequencynumber = t2.dlfrequencynumber)
WHERE
  t1.localcellid != t2.localcellid
ORDER BY
 distance_Km ASC
 LIMIT 30000;
