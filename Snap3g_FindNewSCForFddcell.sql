DROP TABLE IF EXISTS t_list_fddcell;
CREATE TABLE t_list_fddcell
(
  fddcell text
);
INSERT INTO t_list_fddcell ("fddcell") VALUES ('MRS_CC_LE_MERLAN_BIS_U11');

DROP TABLE IF EXISTS t_list_fddcellNewSC;
CREATE TABLE t_list_fddcellNewSC AS
SELECT 
  t1.fddcell, 
  t1.localcellid,
  t1.codenidt,
  --t2.fddcell AS fddcell_distant,
  t2.primaryscramblingcode,
  round(cast(|/((to_number(t1.longitude, '999999999')-to_number(t2.longitude, '999999999')) ^ 2 
	+ (to_number(t1.latitude, '999999999')-to_number(t2.latitude, '999999999')) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_list_fddcell INNER JOIN public.t_topologie3g AS t1
    ON t_list_fddcell.fddcell = t1.fddcell
  INNER JOIN public.t_topologie3g AS t2 
    ON t1.dlfrequencynumber = t2.dlfrequencynumber
WHERE
  t1.localcellid != t2.localcellid AND 
  t2.primaryscramblingcode NOT IN ('506','507','508','509','510','511')

ORDER BY distance_Km DESC;
;


SELECT 
  fddcell, 
  localcellid,
  codenidt,
  primaryscramblingcode,
  MIN(distance_Km) AS Min_distance_Km
FROM 
  t_list_fddcellNewSC
GROUP BY
  fddcell, 
  localcellid,
  codenidt,
  primaryscramblingcode
ORDER BY
  MIN(distance_Km) DESC;
 
