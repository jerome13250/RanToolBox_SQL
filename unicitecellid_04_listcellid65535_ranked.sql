DROP TABLE IF EXISTS tmp_unicitecellid_04_listcellid65535_ranked;
CREATE TABLE tmp_unicitecellid_04_listcellid65535_ranked AS


SELECT *,
row_number() OVER () as rownumber --permet de lister les cellid libre pour faire la jointure avec les cellules
FROM tmp_unicitecellid_03_listcellid65535
WHERE liste_cellid NOT IN (
	SELECT DISTINCT
	t_topologie3g.cellid
	FROM 
	public.t_topologie3g
	WHERE
	cellid IS NOT NULL AND --?????????? => si valeur nulle aucun résultat
	(rnc !='EXTERNAL' --cellules ALU
	OR rncid IN ('358','359','419','438','439','57','58','859','970'))
)

;
