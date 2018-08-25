-- Creation du rapport de puissance 2G G900:
DROP TABLE IF EXISTS t_nokiapower_bts_trxrfpower;
CREATE TABLE t_nokiapower_bts_trxrfpower AS

SELECT 
  t_topologie2g_trx_nokia."BCF_managedObject_distName", 
  t_topologie2g_trx_nokia."BCF_name", 
  t_topologie2g_trx_nokia."BCF_siteTemplateDescription", 
  t_topologie2g_trx_nokia."BTS_managedObject_distName", 
  t_topologie2g_trx_nokia."managedObject_BTS", 
  t_topologie2g_trx_nokia."BTS_name", 
  t_topologie2g_trx_nokia.sectorid, 
  t_topologie2g_trx_nokia."BTS_adminState", 
  t_topologie2g_trx_nokia."frequencyBandInUse", 
  count(t_topologie2g_trx_nokia."managedObject_TRX") AS trx_count, 
  SUM(t_topologie2g_trx_nokia."trxRfPower"::int) AS trxRfPower_sum
FROM 
  public.t_topologie2g_trx_nokia
WHERE
  t_topologie2g_trx_nokia."frequencyBandInUse" = '0' --Filtre sur gsm900
GROUP BY
  t_topologie2g_trx_nokia."BCF_managedObject_distName", 
  t_topologie2g_trx_nokia."BCF_name", 
  t_topologie2g_trx_nokia."BCF_siteTemplateDescription", 
  t_topologie2g_trx_nokia."BTS_managedObject_distName", 
  t_topologie2g_trx_nokia."managedObject_BTS", 
  t_topologie2g_trx_nokia."BTS_name", 
  t_topologie2g_trx_nokia.sectorid, 
  t_topologie2g_trx_nokia."BTS_adminState", 
  t_topologie2g_trx_nokia."frequencyBandInUse"
ORDER BY
  t_topologie2g_trx_nokia."BTS_name";
