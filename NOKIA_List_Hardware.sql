--SRAN16
DROP TABLE IF EXISTS "t_temp_nokia_list_hardware";
CREATE TABLE "t_temp_nokia_list_hardware" AS
--Liste des cartes de type FSM:
SELECT 
  "nokia_SBTS"."managedObject_SBTS", 
  "nokia_SBTS"."sbtsName",
  "nokia_SBTS"."sbtsDescription",
  "nokia_SBTS"."btsProfile",
 "nokia_SBTS"."activeSWReleaseVersion", 
  "nokia_FSM"."managedObject_distName", 
  "nokia_FSM"."inventoryUnitType", 
  "nokia_FSM"."unitPosition", 
  "nokia_FSM"."vendorName", 
  "nokia_FSM"."vendorUnitFamilyType",
  replace("vendorUnitTypeNumber",' ','') AS "vendorUnitTypeNumber", --il y a des espaces dans les numeros de vendorUnitType
  "nokia_FSM"."versionNumber",
  "nokia_FSM"."serialNumber",
  '' AS board_info
FROM 
  public."nokia_FSM", 
  public."nokia_HW", 
  public."nokia_SBTS"
WHERE 
  "nokia_FSM"."managedObject_distName_parent" = "nokia_HW"."managedObject_distName" AND
  "nokia_HW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"

UNION

--Liste des cartes de type calculateur FBBC:
SELECT 
  "nokia_SBTS"."managedObject_SBTS", 
  "nokia_SBTS"."sbtsName", 
  "nokia_SBTS"."sbtsDescription",
  "nokia_SBTS"."btsProfile",
  "nokia_SBTS"."activeSWReleaseVersion",
  "nokia_FBB"."managedObject_distName",  
  "nokia_FBB"."inventoryUnitType",  
  "nokia_FBB"."unitPosition", 
  "nokia_FBB"."vendorName", 
  "nokia_FBB"."vendorUnitFamilyType", 
  replace("nokia_FBB"."vendorUnitTypeNumber",' ',''), --il y a des espaces dans les numeros de vendorUnitTypeNumber
  "nokia_FBB"."versionNumber",
  "nokia_FBB"."serialNumber",
  '' AS board_info
FROM 
  public."nokia_FBB", 
  public."nokia_FSM", 
  public."nokia_HW", 
  public."nokia_SBTS"
WHERE 
  "nokia_FBB"."managedObject_distName_parent" = "nokia_FSM"."managedObject_distName" AND
  "nokia_FSM"."managedObject_distName_parent" = "nokia_HW"."managedObject_distName" AND
  "nokia_HW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"

UNION
--Liste des cartes de type calculateur Radio Module: FR
SELECT 
  "nokia_SBTS"."managedObject_SBTS", 
  "nokia_SBTS"."sbtsName", 
  "nokia_SBTS"."sbtsDescription",
  "nokia_SBTS"."btsProfile",
  "nokia_SBTS"."activeSWReleaseVersion", 
  "nokia_FR"."managedObject_distName", 
  "nokia_FR"."inventoryUnitType",  
  "nokia_FR"."unitPosition", 
  "nokia_FR"."vendorName", 
  "nokia_FR"."vendorUnitFamilyType", 
  replace("vendorUnitTypeNumber",' ',''), --il y a des espaces dans les numeros de vendorUnitTypeNumber
  "nokia_FR"."versionNumber",
  "nokia_FR"."serialNumber",
  ''::text AS board_info
FROM 
  public."nokia_FR" INNER JOIN public."nokia_HW"
  ON
	"nokia_FR"."managedObject_distName_parent" = "nokia_HW"."managedObject_distName"
  INNER JOIN public."nokia_SBTS"
  ON
	"nokia_HW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"

UNION


--SRAN17 :
SELECT -- visu BBMOD SRAN17A ( cartes processing only = FBBC & ABIA)
	"nokia_MRBTS"."managedObject_MRBTS",
    "nokia_MRBTS"."btsName",
    "nokia_MRBTSDESC"."descriptiveName",
    'MRBTS_noProfile'::text AS "btsProfile",
    "nokia_MNL_R"."activeSWReleaseVersion",
    "nokia_BBMOD_R"."managedObject_distName",
	replace(
        replace( --Changement des noms par défaut par des raccourcis:
            "nokia_BBMOD_R"."productName",'Flexi Baseband Sub-Module FBBC','FBBC'),
    'ABIA AirScale Capacity', 'ABIA') AS type_board,
    CASE -- renseigne le numéro de BBMOD
        WHEN "nokia_BBMOD_R"."managedObject_distName" LIKE '%BBMOD_R-1%' THEN 
            '1'
        WHEN "nokia_BBMOD_R"."managedObject_distName" LIKE '%BBMOD_R-2%' THEN   
        	'2'
        WHEN "nokia_BBMOD_R"."managedObject_distName" LIKE '%BBMOD_R-3%' THEN   
        	'3'
        ELSE
            'Error board number'
    END AS "positionInChain",
    'Nokia' AS "vendorName", 
    CASE -- renseigne la FamilyType
        WHEN "nokia_BBMOD_R"."productName" = 'Flexi Baseband Sub-Module FBBC' THEN 
            'FBB'
        WHEN "nokia_BBMOD_R"."productName" = 'ABIA AirScale Capacity' THEN 
        	'ABI'
        ELSE
            'Error BBMOD board'
     END AS "vendorUnitFamilyType", 
  	replace("nokia_BBMOD_R"."productCode",' ','') AS "vendorUnitTypeNumber", --il y a des espaces dans les numeros de vendorUnitTypeNumber
  	'' AS "versionNumber",
  	"nokia_BBMOD_R"."serialNumber",
  	''::text AS board_info
    

FROM "nokia_MRBTS" JOIN "nokia_EQM_R"
ON "nokia_MRBTS"."managedObject_distName" = "nokia_EQM_R"."managedObject_distName_parent"

LEFT JOIN "nokia_APEQM_R"
ON "nokia_EQM_R"."managedObject_distName" = "nokia_APEQM_R"."managedObject_distName_parent"

LEFT JOIN "nokia_CABINET_R"
ON "nokia_APEQM_R"."managedObject_distName" = "nokia_CABINET_R"."managedObject_distName_parent"

RIGHT JOIN "nokia_BBMOD_R" --garde uniquement les sites avec une BBMOD
ON "nokia_CABINET_R"."managedObject_distName" = "nokia_BBMOD_R"."managedObject_distName_parent"

LEFT JOIN "nokia_MRBTSDESC" -- join MRBTS pour la partie NIDT & Software release
ON
"nokia_MRBTS"."managedObject_distName" = "nokia_MRBTSDESC"."managedObject_distName_parent"
LEFT JOIN "nokia_MNL"
ON
"nokia_MRBTS"."managedObject_distName" = "nokia_MNL"."managedObject_distName_parent"
LEFT JOIN "nokia_MNL_R"
ON
"nokia_MNL"."managedObject_distName" = "nokia_MNL_R"."managedObject_distName_parent"

UNION

SELECT -- visu SMOD SRAN17A ( cartes System Module only = FSMF & ASIA)
	
	"nokia_MRBTS"."managedObject_MRBTS",
    "nokia_MRBTS"."btsName",
    "nokia_MRBTSDESC"."descriptiveName",
    'MRBTS_noProfile'::text AS "btsProfile",
    "nokia_MNL_R"."activeSWReleaseVersion",
    "nokia_SMOD_R"."managedObject_distName",
    replace(
        replace( --Changement des noms par défaut par des raccourcis:
            "nokia_SMOD_R"."productName",'Flexi System Module Outdoor FSMF', 'FSMF'),
    'ASIA AirScale Common', 'ASIA') AS type_board,
    
    CASE -- renseigne le numéro de SMOD
        WHEN "nokia_SMOD_R"."managedObject_distName" LIKE '%CABINET_R-1%' THEN 
            '1'
        WHEN "nokia_SMOD_R"."managedObject_distName" LIKE '%CABINET_R-2%' THEN   
        	'2'
        ELSE
            'Error board number'
    END AS "positionInChain",
    'Nokia' AS "vendorName",
    CASE -- renseigne la FamilyType
        WHEN "nokia_SMOD_R"."productName" = 'Flexi System Module Outdoor FSMF' THEN 
            'FSM'
        WHEN "nokia_SMOD_R"."productName" = 'ASIA AirScale Common' THEN 
        	'ASI'
        ELSE
            'Error SMOD board'
 	END AS "vendorUnitFamilyType",
  	replace("nokia_SMOD_R"."productCode",' ','') AS "vendorUnitTypeNumber", --il y a des espaces dans les numeros de vendorUnitTypeNumber
  	'' AS "versionNumber",
  	"nokia_SMOD_R"."serialNumber",
  	''::text AS board_info
    

FROM "nokia_MRBTS" JOIN "nokia_EQM_R"
ON "nokia_MRBTS"."managedObject_distName" = "nokia_EQM_R"."managedObject_distName_parent"

LEFT JOIN "nokia_APEQM_R"
ON "nokia_EQM_R"."managedObject_distName" = "nokia_APEQM_R"."managedObject_distName_parent"

LEFT JOIN "nokia_CABINET_R"
ON "nokia_APEQM_R"."managedObject_distName" = "nokia_CABINET_R"."managedObject_distName_parent"

LEFT JOIN "nokia_SMOD_R" --garde uniquement les sites avec une SMOD
ON "nokia_CABINET_R"."managedObject_distName" = "nokia_SMOD_R"."managedObject_distName_parent"
-- join MRBTS
LEFT JOIN "nokia_MRBTSDESC"
ON
"nokia_MRBTS"."managedObject_distName" = "nokia_MRBTSDESC"."managedObject_distName_parent"
LEFT JOIN "nokia_MNL"
ON
"nokia_MRBTS"."managedObject_distName" = "nokia_MNL"."managedObject_distName_parent"
LEFT JOIN "nokia_MNL_R"
ON
"nokia_MNL"."managedObject_distName" = "nokia_MNL_R"."managedObject_distName_parent"

UNION

SELECT -- visu RMOD SRAN17A ( Radio Module only)

	"nokia_MRBTS"."managedObject_MRBTS",
    "nokia_MRBTS"."btsName",
    "nokia_MRBTSDESC"."descriptiveName",
    'MRBTS_noProfile'::text AS "btsProfile",
    "nokia_MNL_R"."activeSWReleaseVersion",
    "nokia_RMOD_R"."managedObject_distName",
    "nokia_RMOD_R"."productName",
    ''::text AS "positionInChain",
    'Nokia' AS "vendorName", 
    CASE -- renseigne la FamilyType
        WHEN "nokia_RMOD_R"."radioModuleHwReleaseCode" LIKE 'RRH%' THEN 
            'RRH'
        WHEN "nokia_RMOD_R"."radioModuleHwReleaseCode" LIKE 'R_._' THEN 
        	'RM'
        ELSE
            "nokia_RMOD_R"."radioModuleHwReleaseCode"
 	END AS "vendorUnitFamilyType",    
  	replace("nokia_RMOD_R"."productCode",' ','') AS "vendorUnitTypeNumber" , --il y a des espaces dans les numeros de vendorUnitTypeNumber
  	"nokia_RMOD_R"."hwVersion" AS "versionNumber",
  	"nokia_RMOD_R"."serialNumber",
  	''::text AS board_info
    

FROM "nokia_MRBTS" JOIN "nokia_EQM_R"
ON "nokia_MRBTS"."managedObject_distName" = "nokia_EQM_R"."managedObject_distName_parent"

LEFT JOIN "nokia_APEQM_R"
ON "nokia_EQM_R"."managedObject_distName" = "nokia_APEQM_R"."managedObject_distName_parent"

LEFT JOIN "nokia_RMOD_R" 
ON "nokia_APEQM_R"."managedObject_distName" = "nokia_RMOD_R"."managedObject_distName_parent"
-- join MRBTS
LEFT JOIN "nokia_MRBTSDESC"
ON
"nokia_MRBTS"."managedObject_distName" = "nokia_MRBTSDESC"."managedObject_distName_parent"
LEFT JOIN "nokia_MNL"
ON
"nokia_MRBTS"."managedObject_distName" = "nokia_MNL"."managedObject_distName_parent"
LEFT JOIN "nokia_MNL_R"
ON
"nokia_MNL"."managedObject_distName" = "nokia_MNL_R"."managedObject_distName_parent"

ORDER BY
  "sbtsName",
  "vendorUnitFamilyType",
  "inventoryUnitType",
  "unitPosition";


--Creation de la table de référence de mapping entre n° "inventoryUnitType" et dénomination de "vendorUnitTypeNumber"
DROP TABLE IF EXISTS "t_temp_nokia_mapping_inventoryunittype";
CREATE TABLE "t_temp_nokia_mapping_inventoryunittype" AS
SELECT 
  MAX("inventoryUnitType") AS "inventoryUnitType", --permet d'exclure les champs NULL d'inventoryUnitType
  "vendorUnitTypeNumber"
FROM 
  public.t_temp_nokia_list_hardware
WHERE
  "vendorUnitTypeNumber" IS NOT NULL
GROUP BY
  "vendorUnitTypeNumber"
ORDER BY
  "vendorUnitTypeNumber";

--Correction des inventoryUnitType vides 
UPDATE public.t_temp_nokia_list_hardware
  SET "inventoryUnitType" = t_temp_nokia_mapping_inventoryunittype."inventoryUnitType"
FROM 
  public.t_temp_nokia_mapping_inventoryunittype
WHERE
  t_temp_nokia_list_hardware."vendorUnitTypeNumber" = t_temp_nokia_mapping_inventoryunittype."vendorUnitTypeNumber" AND
  t_temp_nokia_list_hardware."inventoryUnitType" IS NULL; --correction des valeurs nulles

--Création de la table finale :
DROP TABLE IF EXISTS "t_nokia_list_hardware";
CREATE TABLE "t_nokia_list_hardware" AS
SELECT 
  * ,
  row_number() OVER (PARTITION BY "managedObject_SBTS","serialNumber" 
			ORDER BY "managedObject_distName" ASC) AS row_number --besoin de créer un index pour supprimer les objets fantomes a l'omc
FROM 
  public.t_temp_nokia_list_hardware;

--Destruction des objets en doublons:
DELETE FROM 
  public.t_nokia_list_hardware
WHERE 
  row_number > 1
;

--Mise à jour du type de board :
UPDATE t_nokia_list_hardware
SET board_info = t_nokia_board_definition.board_info
FROM 
  public.t_nokia_board_definition
WHERE 
  t_nokia_list_hardware."inventoryUnitType" = t_nokia_board_definition.board_type;
  
