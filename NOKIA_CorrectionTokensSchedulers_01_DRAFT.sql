--compte le nombre de secteurs par sbts:
DROP TABLE IF EXISTS t_nokia_site_sector_count;
CREATE TABLE t_nokia_site_sector_count AS
SELECT 
  "WBTS_managedObject_distName", 
  COUNT("SectorID") AS site_sector_count
FROM 
  ( 	SELECT DISTINCT
	t_topologie3g_nokia."WBTS_managedObject_distName",
	t_topologie3g_nokia."SectorID"
	FROM public.t_topologie3g_nokia
  ) AS t
	
GROUP BY
 "WBTS_managedObject_distName";

--requete principale:
DROP TABLE IF EXISTS t_nokia_correctiontokensschedulers_01;
CREATE TABLE t_nokia_correctiontokensschedulers_01 AS
SELECT 
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_topologie3g_nokia."UARFCN", 
  t_topologie3g_nokia."SectorID", 
  right(t_topologie3g_nokia."LCELGW_managedObject_distName",1) AS lcelgwid, 
  t_topologie3g_nokia."Tcell", 
  t_topologie3g_nokia.scheduler_mapping, 
  t_nokia_freqconfig_all.freq_config_all,
  t_nokia_site_sector_count.site_sector_count
FROM 
  public.t_nokia_freqconfig_all INNER JOIN public.t_topologie3g_nokia
  ON 
	t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokia_freqconfig_all."managedObject_distName_parent" AND
	t_topologie3g_nokia."SectorID" = t_nokia_freqconfig_all."SectorID"
  INNER JOIN public.t_nokia_site_sector_count
  ON
	t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokia_site_sector_count."WBTS_managedObject_distName"
ORDER BY
  t_topologie3g_nokia.name ASC;
