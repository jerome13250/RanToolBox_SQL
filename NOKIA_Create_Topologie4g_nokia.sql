--Creation  de la topologie 4g NOKIA
DROP TABLE IF EXISTS t_topologie4g_nokia;
CREATE TABLE t_topologie4g_nokia AS
SELECT DISTINCT
  "nokia_SBTS"."managedObject_SBTS", 
  "nokia_SBTS".name, 
  "nokia_SBTS"."sbtsDescription", 
  "nokia_SBTS"."sbtsName", 
  "nokia_LNCEL"."managedObject_distName", 
  "nokia_LNCEL"."managedObject_LNCEL", 
  "nokia_LNCEL".name AS "LNCEL_name", 
  COALESCE("nokia_LNCEL"."earfcnDL","nokia_LNCEL_FDD"."earfcnDL") AS "earfcnDL", --LNCEL pour SRAN16 mais LNCEL_FDD pour SRAN17
  "nokia_LNCEL"."eutraCelId",
  COALESCE("nokia_LNCEL"."dlChBw","nokia_LNCEL_FDD"."dlChBw") AS "dlChBw", --LNCEL pour SRAN16 mais LNCEL_FDD pour SRAN17
  "nokia_LNCEL"."administrativeState", 
  "nokia_LNCEL"."operationalState",
  "nokia_LNCEL"."pMax"
  
FROM 
  public."nokia_LNCEL" LEFT JOIN public."nokia_LNBTS"
  ON
	"nokia_LNCEL"."managedObject_distName_parent" = "nokia_LNBTS"."managedObject_distName"
  LEFT JOIN public."nokia_SBTS"
  ON
	"nokia_LNBTS"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"
  LEFT JOIN "nokia_LNCEL_FDD"
  ON
	"nokia_LNCEL_FDD"."managedObject_distName_parent" = "nokia_LNCEL"."managedObject_distName"

ORDER BY
  "nokia_LNCEL".name;