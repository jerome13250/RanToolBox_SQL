DROP TABLE IF EXISTS t_ctn_autoplan_sho_limit31;

SELECT * 
FROM (
	SELECT 
		t.*,
		ROW_NUMBER() OVER (PARTITION BY fddcell ORDER BY nbshoplusdetected DESC) AS r
	FROM t_ctn_autoplan_sho AS t
	) AS x
WHERE x.r <=31;
	
