SELECT 
  t_nokia_correctiontokensschedulers_01.site_sector_count,  
  t_nokia_correctiontokensschedulers_01.freq_config_all,
  t_nokia_correctiontokensschedulers_01."SectorID",
  t_nokia_correctiontokensschedulers_01."UARFCN", 
  t_nokia_correctiontokensschedulers_01.lcelgwid, 
  t_nokia_correctiontokensschedulers_01."Tcell",
  COUNT("Tcell") AS count
FROM 
  public.t_nokia_correctiontokensschedulers_01
GROUP BY
  t_nokia_correctiontokensschedulers_01.site_sector_count,  
  t_nokia_correctiontokensschedulers_01.freq_config_all,
  t_nokia_correctiontokensschedulers_01."SectorID",
  t_nokia_correctiontokensschedulers_01."UARFCN", 
  t_nokia_correctiontokensschedulers_01.lcelgwid, 
  t_nokia_correctiontokensschedulers_01."Tcell"
ORDER BY
  t_nokia_correctiontokensschedulers_01.site_sector_count DESC,  
  t_nokia_correctiontokensschedulers_01.freq_config_all,
  t_nokia_correctiontokensschedulers_01."SectorID",
  t_nokia_correctiontokensschedulers_01."UARFCN", 
  COUNT("Tcell") DESC;
