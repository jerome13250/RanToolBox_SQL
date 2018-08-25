-- Creation du mapping LCELW et ANTL
DROP TABLE IF EXISTS t_nokia_lcelw_antl;
CREATE TABLE t_nokia_lcelw_antl AS

SELECT
  "nokia_LCELW"."managedObject_distName" AS "LCELW_managedObject_distName", 
  "nokia_LCELW"."managedObject_LCELW", 
  "nokia_LCELW_resourceList"."LCELW_resourceList", 
  "nokia_LCELW_resourceList"."antlId", 
  "nokia_LCELW_resourceList"."txRxUsage",  
  "nokia_ANTL"."ulDelay", 
  "nokia_ANTL"."antId", 
  "nokia_ANTL"."antennaConnector", 
  "nokia_ANTL".bearing, 
  "nokia_ANTL"."cwaThreshold", 
  "nokia_ANTL"."dcVoltage", 
  "nokia_ANTL".defaults_name, 
  "nokia_ANTL"."feederLoss", 
  "nokia_ANTL"."frRef", 
  "nokia_ANTL"."hdlcCommunicationAllowed", 
  "nokia_ANTL"."lineLoss", 
  "nokia_ANTL"."rModId"
FROM 
  public."nokia_LCELW" INNER JOIN public."nokia_LCELW_resourceList"
  ON
     "nokia_LCELW"."managedObject_distName" = "nokia_LCELW_resourceList"."managedObject_distName"
  INNER JOIN public."nokia_BTSSCW"
  ON
     "nokia_LCELW_resourceList"."managedObject_distName_parent" = "nokia_BTSSCW"."managedObject_distName"
  INNER JOIN public."nokia_ANTL"
  ON
     "nokia_LCELW_resourceList"."antlId" = "nokia_ANTL"."managedObject_ANTL" AND
     "nokia_BTSSCW"."managedObject_distName_parent" = "nokia_ANTL"."managedObject_distName_parent"
ORDER BY 
  "nokia_LCELW"."managedObject_distName";

-- Creation du mapping LCELW et antlid1 antlid2
DROP TABLE IF EXISTS t_nokia_lcelw_crosstab_antlid;
CREATE TABLE t_nokia_lcelw_crosstab_antlid AS

SELECT * FROM crosstab(
   $$
	SELECT "LCELW_managedObject_distName", 
		
		row_number() OVER (PARTITION BY "LCELW_managedObject_distName" ORDER BY "antlId" ASC NULLS LAST) AS rn,
		"antlId"
		--"feederLoss"
	FROM   t_nokia_lcelw_antl
   $$
  , 'VALUES (1),(2)' --Liste les valeurs possibles de row_number
   ) AS t ("LCELW_managedObject_distName" text, "antlId1" text, "antlId2" text);


-- Creation du mapping LCELW et feederLoss1 feederLoss2
DROP TABLE IF EXISTS t_nokia_lcelw_crosstab_feederLoss;
CREATE TABLE t_nokia_lcelw_crosstab_feederLoss AS

SELECT * FROM crosstab(
   $$
	SELECT "LCELW_managedObject_distName", 
		
		row_number() OVER (PARTITION BY "LCELW_managedObject_distName" ORDER BY "antlId" ASC NULLS LAST) AS rn,
		"feederLoss"
	FROM   t_nokia_lcelw_antl
   $$
  , 'VALUES (1),(2)' --Liste les valeurs possibles de row_number
   ) AS t ("LCELW_managedObject_distName" text, "feederLoss1" text, "feederLoss2" text);









