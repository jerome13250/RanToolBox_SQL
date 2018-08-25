SELECT
  primarycell,
  (((to_number(primarycell,'999999999999') - (to_number(primarycell,'999999999999') % 65536 ))/65536)::integer)::text AS rncid,
  (to_number(primarycell,'999999999999') % 65536 )::text AS cellid,
  sum (nb_event) AS nb_event
FROM 
  public.ctn_evt_aggr_modified
WHERE 
  fddcell IS NULL
  --AND   evt_name LIKE '%FAILURE'
GROUP BY
   primarycell,
   cellid,
   rncid
 ORDER BY
  nb_event DESC;
