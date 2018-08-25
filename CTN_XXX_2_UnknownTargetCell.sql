SELECT
  rncs,
  fddcell,
  targetcell,
  (((to_number(targetcell,'999999999999') - (to_number(targetcell,'999999999999') % 65536 ))/65536)::integer)::text AS rncid,
  (to_number(targetcell,'999999999999') % 65536 )::text AS cellid,
  sum (nb_event) AS nb_event
FROM 
  public.ctn_evt_aggr_modified
WHERE 
  umtsfddneighbouringcell IS NULL AND
  targetcell IS NOT NULL
  --AND   evt_name LIKE '%FAILURE'
GROUP BY
   rncs,
   fddcell,
   targetcell,
   cellid,
   rncid
 ORDER BY
  nb_event DESC;
