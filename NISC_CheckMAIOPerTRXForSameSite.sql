SELECT 
  t_topologie2g_trx."BSCName", 
  t_topologie2g_trx."SiteName", 
  t_topologie2g_trx."CellName", 
  t_topologie2g_trx."Rank",
  t_topologie2g_trx."MobileAllocation",
  t_topologie2g_trx."maioTS0", 
  t_topologie2g_trx_2."CellName",
  t_topologie2g_trx_2."Rank",
  t_topologie2g_trx_2."MobileAllocation", 
  t_topologie2g_trx_2."maioTS0"
FROM 
  public.t_topologie2g_trx INNER JOIN public.t_topologie2g_trx t_topologie2g_trx_2
  ON
	t_topologie2g_trx."codeOMC" = t_topologie2g_trx_2."codeOMC" AND
	t_topologie2g_trx."SiteID" = t_topologie2g_trx_2."SiteID" AND
	t_topologie2g_trx."FrequencyRange" = t_topologie2g_trx_2."FrequencyRange" AND
	t_topologie2g_trx."MobileAllocation" = t_topologie2g_trx_2."MobileAllocation"
	
WHERE 
  (t_topologie2g_trx."maioTS0" = t_topologie2g_trx_2."maioTS0" --MAIO Identiques
  OR NULLIF(t_topologie2g_trx."maioTS0",'')::int = NULLIF(t_topologie2g_trx_2."maioTS0",'')::int -1 --MAIO adjacent
  OR NULLIF(t_topologie2g_trx."maioTS0",'')::int = NULLIF(t_topologie2g_trx_2."maioTS0",'')::int +1) --MAIO adjacent

  AND t_topologie2g_trx."nonhoppingTS0" = 'hopping' 
  AND NOT(t_topologie2g_trx."CellInstanceIdentifier" = t_topologie2g_trx_2."CellInstanceIdentifier" AND
     t_topologie2g_trx."Rank" = t_topologie2g_trx_2."Rank")
  ORDER BY
  t_topologie2g_trx."CellName", 
  t_topologie2g_trx."Rank";
