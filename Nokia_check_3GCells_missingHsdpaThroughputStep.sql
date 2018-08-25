--Recherche de tous les hsdpaThroughputStep manquants alors qu'ils existent dans d'autres scheduler du meme SBTS
--Ce probleme conduit a avoir 0 data HSD sur le scheduler sans hsdpaThroughputStep
SELECT DISTINCT
  toposched1."SBTS_managedObject_distName", 
  toposched1."sbtsName", 
  toposched1."sbtsDescription", 
  toposched1."BTSSCW_managedObject_distName", 
  toposched1."LCELGW_managedObject_distName", 
  toposched1."managedObject_LCELGW", 
  toposched1."LCELGW_hsdpaSchedList_sched", 
  toposched1."LCELGW_hsdpaSchedList_hsdpaThroughputStep", 
  toposched1.cell_count, 
  toposched1.cell_list
FROM 
  public.t_topologie3g_nokia_tokens_schedulers toposched1 INNER JOIN public.t_topologie3g_nokia_tokens_schedulers toposched2
  ON
	toposched1."SBTS_managedObject_distName" = toposched2."SBTS_managedObject_distName"
WHERE 
  toposched1."LCELGW_hsdpaSchedList_hsdpaThroughputStep" IS NULL  AND 
  toposched2."LCELGW_hsdpaSchedList_hsdpaThroughputStep" IS NOT NULL AND
  toposched1.cell_count != 0
ORDER BY
  toposched1."sbtsName" 
  ;
