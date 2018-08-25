SELECT 
  t_topologie2g_trx."BSCName", 
  t_topologie2g_trx."SiteName", 
  t_topologie2g_trx."codeOMC", 
  t_topologie2g_trx."SiteID", 
  t_topologie2g_trx."CellName", 
  t_topologie2g_trx."CellInstanceIdentifier", 
  t_topologie2g_trx."FrequencyRange", 
  t_topologie2g_trx."MobileAllocation", 
  t_topologie2g_trx."maioTS0", 
  t_topologie2g_trx."maioTS1", 
  t_topologie2g_trx."maioTS2", 
  t_topologie2g_trx."maioTS3", 
  t_topologie2g_trx."maioTS4", 
  t_topologie2g_trx."maioTS5", 
  t_topologie2g_trx."maioTS6", 
  t_topologie2g_trx."maioTS7"
FROM 
  public.t_topologie2g_trx
WHERE
   t_topologie2g_trx."maioTS0" != t_topologie2g_trx."maioTS1" OR
   t_topologie2g_trx."maioTS0" != t_topologie2g_trx."maioTS2" OR
   t_topologie2g_trx."maioTS0" != t_topologie2g_trx."maioTS3" OR
   t_topologie2g_trx."maioTS0" != t_topologie2g_trx."maioTS4" OR
   t_topologie2g_trx."maioTS0" != t_topologie2g_trx."maioTS5" OR
   t_topologie2g_trx."maioTS0" != t_topologie2g_trx."maioTS6" OR
   t_topologie2g_trx."maioTS0" != t_topologie2g_trx."maioTS7";
