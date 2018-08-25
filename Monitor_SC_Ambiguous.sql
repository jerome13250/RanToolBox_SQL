--Mise en forme de la table des clashs de SC:
DROP TABLE IF EXISTS t_monitor_clashs_sc;
CREATE TABLE t_monitor_clashs_sc AS
SELECT 
  split_part(replace("Supplementary Information",'d',''),' ',1) AS conflicting_SC,
  CASE split_part(replace("Supplementary Information",'d',''),' ',2) 
	WHEN '0' THEN 'yes'
	WHEN '1' THEN 'no'
	ELSE 'unknown'::text
  END AS cell_alarm_rnc_controlled,
  split_part(replace("Supplementary Information",'d',''),' ',3) AS rnc_mcc,
  split_part(replace("Supplementary Information",'d',''),' ',4) AS rnc_mnc,
  split_part(replace("Supplementary Information",'d',''),' ',5) AS rncid,
  split_part(replace("Supplementary Information",'d',''),' ',6) AS cellid
FROM 
  public.monitor_exportedalarms
WHERE
  "Alarm Number" = '3485' --On ne prend que l'alarme SC Conflict
  ;



--Requete Finale :
DROP TABLE IF EXISTS t_monitor_clashs_sc_result;
CREATE TABLE t_monitor_clashs_sc_result AS
SELECT 
  t_monitor_clashs_sc.conflicting_sc, 
  t_monitor_clashs_sc.cell_alarm_rnc_controlled, 
  t_monitor_clashs_sc.rnc_mcc, 
  t_monitor_clashs_sc.rnc_mnc, 
  t_monitor_clashs_sc.rncid, 
  t_monitor_clashs_sc.cellid, 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_topologie3g_nokia."WCEL_managedObject_distName",
  COUNT(t_monitor_clashs_sc.conflicting_sc) AS cell_clash_num,
  t_clash_total.sc_total_clash
FROM 
  public.t_monitor_clashs_sc LEFT JOIN public.t_topologie3g_nokia
  ON
  t_monitor_clashs_sc.rncid = t_topologie3g_nokia."RNC_id" AND
  t_monitor_clashs_sc.cellid = t_topologie3g_nokia."CId"
  INNER JOIN 
	( SELECT --sous requete permettant de compter les occurences par sc de clash
		conflicting_sc,
		COUNT(t_monitor_clashs_sc.conflicting_sc) AS sc_total_clash
	  FROM public.t_monitor_clashs_sc
	  GROUP BY conflicting_sc
	) AS t_clash_total

     ON
	t_monitor_clashs_sc.conflicting_sc = t_clash_total.conflicting_sc

	
GROUP BY
  t_monitor_clashs_sc.conflicting_sc, 
  t_monitor_clashs_sc.cell_alarm_rnc_controlled, 
  t_monitor_clashs_sc.rnc_mcc, 
  t_monitor_clashs_sc.rnc_mnc, 
  t_monitor_clashs_sc.rncid, 
  t_monitor_clashs_sc.cellid, 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_topologie3g_nokia."WCEL_managedObject_distName",
  t_clash_total.sc_total_clash

ORDER BY 
    t_clash_total.sc_total_clash DESC,
    t_monitor_clashs_sc.conflicting_sc::int ASC,
    COUNT(t_monitor_clashs_sc.conflicting_sc) DESC,
    name;





















    
