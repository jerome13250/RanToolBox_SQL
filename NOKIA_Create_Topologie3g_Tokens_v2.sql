SELECT 
  "nokia_WBTS".name AS "WBTS_name",
  "nokia_WBTS"."SBTSId", 
  "nokia_BTSSCW"."numberOfCCCHSet", 
  "nokia_BTSSCW"."numberOfR99ChannelElements", 
  "nokia_BTSSCW"."numberOfHSDPASet1", 
  "nokia_BTSSCW"."numberOfHSDPASet2", 
  "nokia_BTSSCW"."numberOfHSDPASet3", 
  "nokia_BTSSCW"."numberOfHSUPASet1", 
  "nokia_WCEL".name, 
  "nokia_WCEL"."managedObject_WCEL", 
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
   
  "nokia_WCEL"."Tcell",
  "nokia_LCELGW_hsdpaSchedList"."sched" AS "LCELGW_hsdpaSchedList_sched",
  "nokia_LCELGW_hsdpaSchedList"."hsdpaThroughputStep" AS "LCELGW_hsdpaSchedList_hsdpaThroughputStep"
FROM 
  public."nokia_LCELGW"
  LEFT JOIN public."nokia_LCELGW_lCelwIdList"
  ON
	"nokia_LCELGW_lCelwIdList"."managedObject_distName" = "nokia_LCELGW"."managedObject_distName"
  LEFT JOIN public."nokia_LCELGW_hsdpaSchedList"
  ON
	"nokia_LCELGW_hsdpaSchedList"."managedObject_distName" = "nokia_LCELGW"."managedObject_distName"

  LEFT JOIN public."nokia_WCEL"
  ON
	"nokia_WCEL"."managedObject_WCEL" = "nokia_LCELGW_lCelwIdList".p_noname
  LEFT JOIN public."nokia_WBTS"
  ON
	"nokia_WCEL"."managedObject_distName_parent" = "nokia_WBTS"."managedObject_distName"
  LEFT JOIN public."nokia_BTSSCW"
  ON
	"nokia_LCELGW"."managedObject_distName_parent" = "nokia_BTSSCW"."managedObject_distName"

WHERE 
   (--Permet de faire la jonction entre Tcell et scheduler number :
   ("nokia_WCEL"."Tcell" IN ('0','1','2','6','7','8') AND "nokia_LCELGW_hsdpaSchedList"."sched" = '1')
   OR
   ("nokia_WCEL"."Tcell" IN ('3','4','5','9') AND "nokia_LCELGW_hsdpaSchedList"."sched" = '2')
   OR "nokia_WCEL"."Tcell" IS NULL
   OR "nokia_LCELGW_hsdpaSchedList"."sched" IS NULL )


  --AND "nokia_WBTS".name = 'BONS_TDF'

	
   
ORDER BY
  "nokia_WCEL".name ASC,
  "nokia_LCELGW_hsdpaSchedList"."sched";
