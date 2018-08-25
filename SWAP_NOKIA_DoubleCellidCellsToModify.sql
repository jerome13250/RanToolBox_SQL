DROP TABLE IF EXISTS tmp_unicitecellid_02_listcellstomodify;
CREATE TABLE tmp_unicitecellid_02_listcellstomodify AS

SELECT 
  t_ranked.*,
  row_number() OVER () as rownumber
  
FROM (
	SELECT 
	t.*,
	ROW_NUMBER() OVER (PARTITION BY cellid ORDER BY info DESC, fddcell ASC) AS ranking
	FROM 
	public.tmp_unicitecellid_01_listcellsdoubles AS t
      ) AS t_ranked
WHERE 
	ranking !=1 AND
	info != 'swap_nokia'
;


	

