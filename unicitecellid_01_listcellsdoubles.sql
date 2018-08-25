--Donne la liste de toutes les cellules en doublons de cellid:
DROP TABLE IF EXISTS tmp_unicitecellid_01_listcellsdoubles;
CREATE TABLE tmp_unicitecellid_01_listcellsdoubles AS

SELECT 
 t_topologie3g.rnc,
 t_topologie3g.rncid,
 t_topologie3g.fddcell,
 t_topologie3g.localcellid,
 t_topologie3g.cellid,
 CASE 	WHEN rncid IN ('358','359','419','438','439','57','58','859','970') THEN 'swap_nokia' --permet d'isoler les cellules nokia a ne pas modifier
	WHEN rncid = '999999' THEN 'aaa_reservation_topo'
	WHEN rnc LIKE 'RS\_%' THEN 'ransharing' --permet d'isoler les cellules ransharing qui ont une plage de cellid reservé
	WHEN bdref_list_cells_gel."LCID" IS NOT NULL THEN 'swap_gel_zone'
        ELSE 'normal' END 
	AS info
 
FROM
  t_topologie3g  LEFT JOIN bdref_list_cells_gel --Permet de prioriser les cellules non-gelees
  ON
	t_topologie3g.localcellid = bdref_list_cells_gel."LCID"
 
WHERE cellid IN 
	(SELECT --sous requete listant les cellid en doublon
	  t_topologie3g.cellid 
	  --COUNT(t_topologie3g.cellid) AS nb_doubles
	FROM 
	  public.t_topologie3g
	WHERE 
	   rnc !='EXTERNAL'
	   OR rncid IN ('358','359','419','438','439','57','58','859','970')

	GROUP BY
	  t_topologie3g.cellid
	HAVING
	  COUNT(t_topologie3g.cellid)>1
	)

 AND (rnc !='EXTERNAL' --cellules ALU
   OR rncid IN ('358','359','419','438','439','57','58','859','970')) --cellules NOKIA


ORDER BY cellid::int


;
