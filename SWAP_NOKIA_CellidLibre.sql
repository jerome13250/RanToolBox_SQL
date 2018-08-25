SELECT *,
row_number() OVER () as rownumber
FROM tmp_unicitecellid_03_listcellid65535
WHERE liste_cellid NOT IN (
	SELECT DISTINCT
	t_topologie3g.cellid
	FROM 
	public.t_topologie3g
	WHERE
	rnc !='EXTERNAL' --cellules ALU
	OR rncid IN ('419','58','57','358','359','439','438')
)

;
