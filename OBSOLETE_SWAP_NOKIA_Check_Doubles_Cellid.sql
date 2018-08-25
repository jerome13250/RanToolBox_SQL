DROP TABLE IF EXISTS tmp_unicitecellid_01_listcellsdoubles;
CREATE TABLE tmp_unicitecellid_01_listcellsdoubles AS


SELECT 
 t_topologie3g.rnc,
 t_topologie3g.rncid,
 t_topologie3g.fddcell,
 t_topologie3g.localcellid,
 t_topologie3g.cellid,
 CASE 	WHEN rncid IN ('419','58','57','358','359','439','438') THEN 'swap_nokia'
	WHEN rnc LIKE 'RS\_%' THEN 'ransharing'
        ELSE 'normal' END 
	AS info
 
FROM
 t_topologie3g
WHERE cellid IN
(SELECT 
  t_topologie3g.cellid 
  --COUNT(t_topologie3g.cellid) AS nb_doubles
FROM 
  public.t_topologie3g
WHERE 
   rnc !='EXTERNAL'
   OR rncid IN ('419','58','57','358','359','439','438')

GROUP BY
  t_topologie3g.cellid
HAVING
  COUNT(t_topologie3g.cellid)>1
)

 AND (rnc !='EXTERNAL' --cellules ALU
   OR rncid IN ('419','58','57','358','359','439','438')) --cellules NOKIA


ORDER BY cellid::int
;
