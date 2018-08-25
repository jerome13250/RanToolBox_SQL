--On crée la liste des schedulers d'apres le paramètre "hspaSetting"

DROP TABLE IF EXISTS tmp_nokia_schedulers;
CREATE TABLE tmp_nokia_schedulers AS


	SELECT 
	  "nokia_SBTS"."managedObject_distName" AS "SBTS_managedObject_distName",
	  "nokia_SBTS"."sbtsName",
	  "nokia_SBTS"."sbtsDescription",
	  "nokia_LCELGW"."managedObject_distName_parent" AS "BTSSCW_managedObject_distName",
	  "nokia_LCELGW"."managedObject_distName" AS "LCELGW_managedObject_distName",
	  "nokia_LCELGW"."managedObject_LCELGW", 
	  "nokia_LCELGW"."cellGroupName", 
	  "nokia_LCELGW"."accessBbCapacity", 
	  "nokia_LCELGW"."shareOfHSDPAUser", 
	  "nokia_LCELGW"."shareOfHSUPACapacity", 
	  "nokia_LCELGW"."hspaSetting",
	   CASE "hspaSetting"
		WHEN '0' THEN 'Rel.99 only'
		WHEN '1' THEN 'Normal HSPA-2 hspa sched.'
		WHEN '2' THEN 'Small HSPA-1 hspa sched.'
		ELSE NULL END 
		AS "hspaSetting_info",
	  '1' AS "scheduler_index"
	  
	  --"nokia_LCELGW_hsdpaSchedList"."sched" AS "LCELGW_hsdpaSchedList_sched",
	  --"nokia_LCELGW_hsdpaSchedList"."hsdpaThroughputStep" AS "LCELGW_hsdpaSchedList_hsdpaThroughputStep"
	FROM 
	  public."nokia_LCELGW" INNER JOIN "nokia_BTSSCW"
	  ON
	    "nokia_LCELGW"."managedObject_distName_parent" = "nokia_BTSSCW"."managedObject_distName"
	  INNER JOIN "nokia_SBTS"
	  ON
	    "nokia_BTSSCW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"
	WHERE
		"hspaSetting" IN ('0','1','2') -- le 2eme scheduler pour "Normal HSPA" sera ajouté avec UNION 

	UNION

	SELECT 
	  "nokia_SBTS"."managedObject_distName" AS "SBTS_managedObject_distName",
	  "nokia_SBTS"."sbtsName",
	  "nokia_SBTS"."sbtsDescription",
	  "nokia_LCELGW"."managedObject_distName_parent" AS "BTSSCW_managedObject_distName",
	  "nokia_LCELGW"."managedObject_distName" AS "LCELGW_managedObject_distName",
	  "nokia_LCELGW"."managedObject_LCELGW", 
	  "nokia_LCELGW"."cellGroupName", 
	  "nokia_LCELGW"."accessBbCapacity", 
	  "nokia_LCELGW"."shareOfHSDPAUser", 
	  "nokia_LCELGW"."shareOfHSUPACapacity", 
	  "nokia_LCELGW"."hspaSetting",
	   CASE "hspaSetting"
		WHEN '0' THEN 'Rel.99 only'
		WHEN '1' THEN 'Normal HSPA-2 hspa sched.'
		WHEN '2' THEN 'Small HSPA-1 hspa sched.'
		ELSE NULL END 
		AS "hspaSetting_info",
	   '2' AS "scheduler_index"
	FROM 
	  public."nokia_LCELGW" INNER JOIN "nokia_BTSSCW"
	  ON
	    "nokia_LCELGW"."managedObject_distName_parent" = "nokia_BTSSCW"."managedObject_distName"
	  INNER JOIN "nokia_SBTS"
	  ON
	    "nokia_BTSSCW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"
	WHERE
		"hspaSetting" = '1' -- le 2eme scheduler pour "Normal HSPA" 

	ORDER BY
	"LCELGW_managedObject_distName",
	"scheduler_index"
;

--On fait le lien entre les schedulers d'apres le paramètre "hspaSetting" et les hsdpaSchedList (ils ne sont pas tous remplis)
DROP TABLE IF EXISTS tmp_nokia_schedulers_througput;
CREATE TABLE tmp_nokia_schedulers_througput AS

SELECT 
  tmp_nokia_schedulers."SBTS_managedObject_distName",
  tmp_nokia_schedulers."sbtsName",
  tmp_nokia_schedulers."sbtsDescription",
  tmp_nokia_schedulers."BTSSCW_managedObject_distName",
  "nokia_BTSSCW"."numberOfCCCHSet", 
  "nokia_BTSSCW"."numberOfR99ChannelElements", 
  "nokia_BTSSCW"."numberOfHSDPASet1", 
  "nokia_BTSSCW"."numberOfHSDPASet2", 
  "nokia_BTSSCW"."numberOfHSDPASet3", 
  "nokia_BTSSCW"."numberOfHSUPASet1",
  tmp_nokia_schedulers."LCELGW_managedObject_distName", 
  tmp_nokia_schedulers."managedObject_LCELGW", 
  tmp_nokia_schedulers."cellGroupName", 
  tmp_nokia_schedulers."accessBbCapacity",
  floor("numberOfR99ChannelElements"::int*tmp_nokia_schedulers."accessBbCapacity"::int/100) AS "Per_LCG_accessBbCapacity",
  tmp_nokia_schedulers."shareOfHSDPAUser",
  floor(("numberOfHSDPASet2"::int+"numberOfHSDPASet3"::int)*72*"shareOfHSDPAUser"::int/100) AS "Per_LCG_HSDPA_User", 
  tmp_nokia_schedulers."shareOfHSUPACapacity",
  floor("numberOfHSUPASet1"::int*"shareOfHSUPACapacity"::int/100) +
	  CASE tmp_nokia_schedulers."managedObject_LCELGW"
		WHEN '1' THEN ("numberOfHSUPASet1"::int - floor("numberOfHSUPASet1"::int*"shareOfHSUPACapacity"::int/100) - floor("numberOfHSUPASet1"::int*(100-"shareOfHSUPACapacity"::int)/100))
		ELSE 0 END 
		AS "Per_LCG_HSUPA_LicenceKey",
  tmp_nokia_schedulers."hspaSetting", 
  tmp_nokia_schedulers."hspaSetting_info", 
  tmp_nokia_schedulers.scheduler_index, 
  "nokia_LCELGW_hsdpaSchedList".sched AS "LCELGW_hsdpaSchedList_sched", 
  "nokia_LCELGW_hsdpaSchedList"."hsdpaThroughputStep"::int AS "LCELGW_hsdpaSchedList_hsdpaThroughputStep"
FROM 
  public.tmp_nokia_schedulers LEFT JOIN public."nokia_LCELGW_hsdpaSchedList" --hsdpaSchedList pas tous remplis donc LEFT JOIN
  ON 
  tmp_nokia_schedulers."LCELGW_managedObject_distName" = "nokia_LCELGW_hsdpaSchedList"."managedObject_distName" AND
  tmp_nokia_schedulers.scheduler_index = "nokia_LCELGW_hsdpaSchedList".sched

  INNER JOIN "nokia_BTSSCW"
  ON
	tmp_nokia_schedulers."BTSSCW_managedObject_distName" = "nokia_BTSSCW"."managedObject_distName"
  ;

--On rajoute la somme
DROP TABLE IF EXISTS tmp_nokia_schedulers_througput_sum;
CREATE TABLE tmp_nokia_schedulers_througput_sum AS
SELECT 
  tmp_nokia_schedulers_througput.*,
  t_sum."sum_hsdpaThroughputStep",
  floor(("numberOfHSDPASet2"::int + 4*"numberOfHSDPASet3"::int)*"LCELGW_hsdpaSchedList_hsdpaThroughputStep"::int/
	t_sum."sum_hsdpaThroughputStep") AS "Per_scheduler_LK21mbps_approximative"

FROM tmp_nokia_schedulers_througput INNER JOIN 
	(SELECT 
	  tmp_nokia_schedulers_througput."BTSSCW_managedObject_distName", 
	  SUM(tmp_nokia_schedulers_througput."LCELGW_hsdpaSchedList_hsdpaThroughputStep") AS "sum_hsdpaThroughputStep"	  
	FROM 
	  public.tmp_nokia_schedulers_througput
	GROUP BY
	  tmp_nokia_schedulers_througput."BTSSCW_managedObject_distName") AS t_sum
ON
  tmp_nokia_schedulers_througput."BTSSCW_managedObject_distName" = t_sum."BTSSCW_managedObject_distName";



DROP TABLE IF EXISTS t_topologie3g_nokia_tokens_schedulers;
CREATE TABLE t_topologie3g_nokia_tokens_schedulers AS

SELECT 
  tmp_nokia_schedulers_througput_sum."SBTS_managedObject_distName",
  tmp_nokia_schedulers_througput_sum."sbtsName",
  tmp_nokia_schedulers_througput_sum."sbtsDescription",
  tmp_nokia_schedulers_througput_sum."BTSSCW_managedObject_distName", 
  tmp_nokia_schedulers_througput_sum."numberOfCCCHSet", 
  tmp_nokia_schedulers_througput_sum."numberOfR99ChannelElements", 
  tmp_nokia_schedulers_througput_sum."numberOfHSDPASet1", 
  tmp_nokia_schedulers_througput_sum."numberOfHSDPASet2", 
  tmp_nokia_schedulers_througput_sum."numberOfHSDPASet3", 
  tmp_nokia_schedulers_througput_sum."numberOfHSUPASet1", 
  tmp_nokia_schedulers_througput_sum."LCELGW_managedObject_distName", 
  tmp_nokia_schedulers_througput_sum."managedObject_LCELGW", 
  tmp_nokia_schedulers_througput_sum."cellGroupName", 
  tmp_nokia_schedulers_througput_sum."accessBbCapacity", 
  tmp_nokia_schedulers_througput_sum."Per_LCG_accessBbCapacity", 
  tmp_nokia_schedulers_througput_sum."shareOfHSDPAUser", 
  tmp_nokia_schedulers_througput_sum."Per_LCG_HSDPA_User", 
  tmp_nokia_schedulers_througput_sum."shareOfHSUPACapacity", 
  tmp_nokia_schedulers_througput_sum."Per_LCG_HSUPA_LicenceKey", 
  tmp_nokia_schedulers_througput_sum."hspaSetting", 
  tmp_nokia_schedulers_througput_sum."hspaSetting_info", 
  tmp_nokia_schedulers_througput_sum.scheduler_index, 
  tmp_nokia_schedulers_througput_sum."LCELGW_hsdpaSchedList_sched", 
  tmp_nokia_schedulers_througput_sum."LCELGW_hsdpaSchedList_hsdpaThroughputStep", 
  tmp_nokia_schedulers_througput_sum."sum_hsdpaThroughputStep", 
  tmp_nokia_schedulers_througput_sum."Per_scheduler_LK21mbps_approximative",
  COUNT(t_topologie3g_nokia."managedObject_WCEL") AS cell_count,
  string_agg(right(t_topologie3g_nokia.name,3),'-' ORDER BY t_topologie3g_nokia.name) AS cell_list

FROM 
  public.tmp_nokia_schedulers_througput_sum LEFT JOIN public.t_topologie3g_nokia --left car certains lcg ou sched n'ont pas de cellules allouées
  ON 
	  tmp_nokia_schedulers_througput_sum."LCELGW_managedObject_distName" = t_topologie3g_nokia."LCELGW_managedObject_distName" AND
	  tmp_nokia_schedulers_througput_sum.scheduler_index = t_topologie3g_nokia.scheduler_mapping
GROUP BY 
tmp_nokia_schedulers_througput_sum."SBTS_managedObject_distName",
  tmp_nokia_schedulers_througput_sum."sbtsName",
  tmp_nokia_schedulers_througput_sum."sbtsDescription",
  tmp_nokia_schedulers_througput_sum."BTSSCW_managedObject_distName", 
  tmp_nokia_schedulers_througput_sum."numberOfCCCHSet", 
  tmp_nokia_schedulers_througput_sum."numberOfR99ChannelElements", 
  tmp_nokia_schedulers_througput_sum."numberOfHSDPASet1", 
  tmp_nokia_schedulers_througput_sum."numberOfHSDPASet2", 
  tmp_nokia_schedulers_througput_sum."numberOfHSDPASet3", 
  tmp_nokia_schedulers_througput_sum."numberOfHSUPASet1", 
  tmp_nokia_schedulers_througput_sum."LCELGW_managedObject_distName", 
  tmp_nokia_schedulers_througput_sum."managedObject_LCELGW", 
  tmp_nokia_schedulers_througput_sum."cellGroupName", 
  tmp_nokia_schedulers_througput_sum."accessBbCapacity", 
  tmp_nokia_schedulers_througput_sum."Per_LCG_accessBbCapacity", 
  tmp_nokia_schedulers_througput_sum."shareOfHSDPAUser", 
  tmp_nokia_schedulers_througput_sum."Per_LCG_HSDPA_User", 
  tmp_nokia_schedulers_througput_sum."shareOfHSUPACapacity", 
  tmp_nokia_schedulers_througput_sum."Per_LCG_HSUPA_LicenceKey", 
  tmp_nokia_schedulers_througput_sum."hspaSetting", 
  tmp_nokia_schedulers_througput_sum."hspaSetting_info", 
  tmp_nokia_schedulers_througput_sum.scheduler_index, 
  tmp_nokia_schedulers_througput_sum."LCELGW_hsdpaSchedList_sched", 
  tmp_nokia_schedulers_througput_sum."LCELGW_hsdpaSchedList_hsdpaThroughputStep", 
  tmp_nokia_schedulers_througput_sum."sum_hsdpaThroughputStep", 
  tmp_nokia_schedulers_througput_sum."Per_scheduler_LK21mbps_approximative"
ORDER BY 
  tmp_nokia_schedulers_througput_sum."sbtsName",
  tmp_nokia_schedulers_througput_sum."managedObject_LCELGW",
  tmp_nokia_schedulers_througput_sum.scheduler_index;

