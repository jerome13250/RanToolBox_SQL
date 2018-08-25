SELECT DISTINCT
  "managedObject_SBTS", 
  string_agg("earfcnDL", '-' ORDER BY "earfcnDL") AS freq_config
FROM 
  ( SELECT DISTINCT
	t_topologie4g_nokia."managedObject_SBTS", 
	t_topologie4g_nokia."earfcnDL"
	FROM t_topologie4g_nokia
	ORDER BY "earfcnDL"
  ) AS t

GROUP BY
  t."managedObject_SBTS"

/*
  SELECT 
  t_topologie4g_nokia."managedObject_SBTS", 
  t_topologie4g_nokia."earfcnDL"
FROM 
  public.t_topologie4g_nokia;
*/