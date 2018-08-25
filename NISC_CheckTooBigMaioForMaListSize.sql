SELECT 
  t_topologie2g_trx."BSCName", 
  t_topologie2g_trx."SiteName", 
  t_topologie2g_trx."codeOMC", 
  t_topologie2g_trx."SiteID", 
  t_topologie2g_trx."CellName", 
  t_topologie2g_trx."CellInstanceIdentifier", 
  t_topologie2g_trx."MobileAllocation",
  length(t_topologie2g_trx."MobileAllocation")-length(replace(t_topologie2g_trx."MobileAllocation",'_','')) AS ma_index_max, 
  t_topologie2g_trx."maioTS0"

FROM 
  public.t_topologie2g_trx

WHERE
  NULLIF(t_topologie2g_trx."maioTS0",'')::int >= length(t_topologie2g_trx."MobileAllocation")-length(replace(t_topologie2g_trx."MobileAllocation",'_',''))

ORDER BY
  t_topologie2g_trx."CellName"
  ;
