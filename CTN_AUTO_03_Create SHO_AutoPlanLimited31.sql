DROP TABLE IF EXISTS t_ctn_autoplan_sho_limit31;

SELECT * INTO t_ctn_autoplan_sho_limit31
FROM t_ctn_autoplan_sho AS auto1
WHERE 
	( 31>(SELECT COUNT(auto2.fddcell)
		FROM t_ctn_autoplan_sho AS auto2
		WHERE auto2.nbshoplusdetected > auto1.nbshoplusdetected
		AND auto2.fddcell = auto1.fddcell));