SELECT 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_topologie3g_nokia."AdminCellState", 
  t_topologie3g_nokia."WCelState", 
  t_topologie3g_nokia."WCEL_managedObject_distName", 
  t_topologie3g_nokia."LCELGW_managedObject_distName", 
  t_topologie3g_nokia."Tcell", 
  t_topologie3g_nokia.scheduler_mapping
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_topologie3g_nokia_tokens_schedulers
  ON
	t_topologie3g_nokia."SBTS_managedObject_distName" = t_topologie3g_nokia_tokens_schedulers."SBTS_managedObject_distName" AND
	t_topologie3g_nokia.scheduler_mapping = t_topologie3g_nokia_tokens_schedulers.scheduler_index AND
	t_topologie3g_nokia."LCELGW_managedObject_distName" = t_topologie3g_nokia_tokens_schedulers."LCELGW_managedObject_distName"
WHERE 
  t_topologie3g_nokia_tokens_schedulers."SBTS_managedObject_distName" IS NULL AND
  t_topologie3g_nokia."LCELGW_managedObject_distName" IS NOT NULL;