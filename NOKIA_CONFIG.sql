DROP TABLE IF EXISTS "tmp_HW_inventory";
-- creation table temporaire
CREATE  TABLE "tmp_HW_inventory" AS 
    --TCD via POSTGRESQL
    SELECT * FROM crosstab(
        $$
        -- select sous forme Clef, Future colonne, valeur
        SELECT 
	      "managedObject_SBTS" AS Clef,
	      "sbtsDescription" AS "CodeGN",
          "sbtsName",
          "btsProfile",
          "activeSWReleaseVersion",
          "inventoryUnitType",
          COUNT("inventoryUnitType") AS counter
        FROM 
          public.t_nokia_list_hardware
        GROUP BY
          "sbtsDescription",
          "managedObject_SBTS",
          "sbtsName",
          "btsProfile",
          "activeSWReleaseVersion",
          "inventoryUnitType"

	UNION
	--Calcul spécial sur la position FBBC du FSMF-1:
	 	 SELECT 
          "managedObject_SBTS" AS Clef,
		  "sbtsDescription" AS "CodeGN",
          "sbtsName", 
          "btsProfile",
          "activeSWReleaseVersion",
          'FBB_FSM1'::text AS "inventoryUnitType",
          COUNT("inventoryUnitType") AS counter
        FROM 
          public.t_nokia_list_hardware
        WHERE 
        	"inventoryUnitType" = 'FBBC' AND "managedObject_distName"  LIKE '%CABINET_R-1/B%' OR "managedObject_distName" LIKE '%/FSM-1/%'  --On compte les FBBC que sur FSM-1 ou CABINET-1
        GROUP BY
          "sbtsDescription",
          "managedObject_SBTS",
          "sbtsName",
          "btsProfile",
          "activeSWReleaseVersion",
          "inventoryUnitType"

        UNION

	--Calcul spécial sur la position FBBC du FSMF-2:
	 SELECT 
          "managedObject_SBTS" AS Clef,
	      "sbtsDescription" AS "CodeGN",
          "sbtsName", 
          "btsProfile",
          "activeSWReleaseVersion",
          'FBB_FSM2'::text AS "inventoryUnitType",
          COUNT("inventoryUnitType") AS counter
        FROM 
          public.t_nokia_list_hardware
        WHERE 
           "inventoryUnitType" = 'FBBC' AND "managedObject_distName"  LIKE '%CABINET_R-2/B%' OR "managedObject_distName" LIKE '%/FSM-2/%' --On compte les FBBC que sur FSM-2 ou CABINET-2
        GROUP BY
          "sbtsDescription",
          "managedObject_SBTS",
          "sbtsName",
          "btsProfile",
          "activeSWReleaseVersion",
          "inventoryUnitType"

 
		 
        ORDER BY
         "clef";
        $$,
        -- select sous forme Clef, Future colonne, valeur

        $$VALUES ('FXDB'::text),
            ('FXDD'::text), ('FXED'::text), ('FRGU'::text), ('FRGX'::text), ('FRMF'::text), ('FRHC'::text),
            ('FHDB'::text), ('FHEB'::text), ('FHEL'::text), ('FRGY'::text), ('FRMB'::text),
        	('FRHG'::text), ('FSMF'::text), ('FBBC'::text), ('FBB_FSM1'::text), ('FBB_FSM2'::text),
			('ASIA'::text), ('ABIA'::text)
		$$)

    AS ct (  "SBTSID" text, "NIDT" text , "sbtsName" text,"btsProfile" text, "activeSWReleaseVersion" text,
        "FXDB" int, "FXDD" int, "FXED" int, "FRGU" int, "FRGX" int, "FRMF" int, "FRHC" int,
            "FHDB" int, "FHEB" int, "FHEL" int, "FRGY" int, "FRMB" int, "FRHG" int,
            "FSMF" int, "FBBC" int, "FBB_FSM1" int, "FBB_FSM2" int, "ASIA" int, "ABIA" int);
-- fin TCD PostGreSQL

-- remplacement des NULL par des zéro via un UPDATE de la table
UPDATE "tmp_HW_inventory"
SET 
    "FXDB"=COALESCE("FXDB", '0'),
    "FXDD"=COALESCE("FXDD", '0'),
    "FXED"=COALESCE("FXED", '0'),
    "FRGU"=COALESCE("FRGU", '0'),
    "FRGX"=COALESCE("FRGX", '0'),
    "FRMF"=COALESCE("FRMF", '0'),
    "FRHC"=COALESCE("FRHC", '0'),
    "FHDB"=COALESCE("FHDB", '0'),
    "FHEB"=COALESCE("FHEB", '0'),
    "FHEL"=COALESCE("FHEL", '0'),
    "FRGY"=COALESCE("FRGY", '0'),
    "FRMB"=COALESCE("FRMB", '0'),
    "FRHG"=COALESCE("FRHG", '0'),
    "FSMF"=COALESCE("FSMF", '0'),
    "FBBC"=COALESCE("FBBC", '0'),
    "FBB_FSM1"=COALESCE("FBB_FSM1", '0'),
    "FBB_FSM2"=COALESCE("FBB_FSM2", '0'),
	"ASIA"=COALESCE("ASIA", '0'),
    "ABIA"=COALESCE("ABIA", '0')
;
-- fin remplacement des NULL par des zéro via un UPDATE de la table


-- ajout de la colonne clef_configuration  et remplissage de cette colonne via concatenation
ALTER TABLE "tmp_HW_inventory" ADD COLUMN clef_configuration text;
UPDATE "tmp_HW_inventory" SET clef_configuration = 
    'FXDB'||CAST("tmp_HW_inventory"."FXDB" as text)|| '-' ||
    'FXDD'||CAST("tmp_HW_inventory"."FXDD" as text)|| '-' ||
    'FXED'||CAST("tmp_HW_inventory"."FXED" as text)|| '-' ||
    'FRGU'||CAST("tmp_HW_inventory"."FRGU" as text)|| '-' ||
    'FRGX'||CAST("tmp_HW_inventory"."FRGX" as text)|| '-' ||
    'FRMF'||CAST("tmp_HW_inventory"."FRMF" as text)|| '-' ||
    'FRHC'||CAST("tmp_HW_inventory"."FRHC" as text)|| '-' ||
    --case pour affecter 3 aux conf RRH
    'FHDB'||CAST(CASE "tmp_HW_inventory"."FHDB" WHEN 0 THEN 0 ELSE 3 END as text)|| '-' ||
    'FHEB'||CAST(CASE "tmp_HW_inventory"."FHEB" WHEN 0 THEN 0 ELSE 3 END as text)|| '-' ||
    'FHEL'||CAST(CASE "tmp_HW_inventory"."FHEL" WHEN 0 THEN 0 ELSE 3 END as text)|| '-' ||
    'FRGY'||CAST(CASE "tmp_HW_inventory"."FRGY" WHEN 0 THEN 0 ELSE 3 END as text)|| '-' ||
    'FRMB'||CAST(CASE "tmp_HW_inventory"."FRMB" WHEN 0 THEN 0 ELSE 3 END as text)|| '-' ||
    'FRHG'||CAST(CASE "tmp_HW_inventory"."FRHG" WHEN 0 THEN 0 ELSE 3 END as text)|| '-' ||
    'FSMF'||CAST("tmp_HW_inventory"."FSMF" as text)|| '-' ||
    'ASIA'||CAST("tmp_HW_inventory"."ASIA" as text)|| '-' ||
    'Profil'||CAST("tmp_HW_inventory"."btsProfile" as text);
    
-- fin ajout de la colonne clef_configuration  et remplissage de cette colonne via concatenation
--SELECT * FROM "tmp_HW_inventory";

DROP TABLE IF EXISTS t_nokia_hw_configorange;
CREATE TABLE t_nokia_hw_configorange AS
SELECT
    "SBTSID",
    "NIDT",
    "sbtsName",
    "btsProfile",
     COALESCE ("t_nokia_configuration"."configuration_alias",'__NoConf__') AS "Configuration_Alias",
     COALESCE ("t_nokia_configuration"."configuration_alias_details",'__NoConf__') AS "Configuration_Alias_Details",
    "FXDB", "FXDD","FXED",
    "FRGU", "FRGX",
    "FRMF", "FRHC",
    "FHDB", "FHEB",
    "FHEL","FRGY",
    "FRMB", "FRHG",
    "FSMF", "FBBC",
    "FBB_FSM1", "FBB_FSM2",
	"ASIA", "ABIA",
    "activeSWReleaseVersion",
    "tmp_HW_inventory"."clef_configuration"
FROM "tmp_HW_inventory" LEFT JOIN "t_nokia_configuration" 
	ON "tmp_HW_inventory"."clef_configuration" = "t_nokia_configuration"."clef_configuration"
ORDER BY 
   "sbtsName";
