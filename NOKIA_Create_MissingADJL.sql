--ATTENTION !!!! LTE800 20Mhz pour tous les RAN sharing dont Orange "ADJL_LTE800_RS" EARFCN=6275, FREE ne doit pas être sur 700 ?????
--ATTENTION !!!! LTE2100 15 MHz non géré + Kinsei avec mauvaise fréquence earfcn !!!

ANALYZE "nokia_WCEL";

DROP TABLE IF EXISTS t_adjl_generic_create;
CREATE TABLE t_adjl_generic_create AS

--ADJL 2600 manquant à créer :
SELECT 
  "nokia_WCEL".name AS "NOM",  
  "nokia_WCEL"."managedObject_WCEL",
  "managedObject_version",
  "WCELMCC",
  "WCELMNC",
  "nokia_WCEL"."managedObject_distName" || '/ADJL-1' AS "managedObject_distName",
  CASE "WCELMNC"
	WHEN '01' THEN '3000'::text --Orange
	WHEN '10' THEN '2825'::text --SFR
	WHEN '20' THEN '3175'::text --BYT
	WHEN '15' THEN '3350'::text --FRM
	ELSE 'ERROR' 
   END AS "AdjLEARFCN",
  CASE "WCELMNC"
	WHEN '01' THEN '100'::text --Orange
	WHEN '10' THEN '75'::text --SFR
	WHEN '20' THEN '75'::text --BYT
	WHEN '15' THEN '100'::text --FRM
	ELSE 'ERROR' 
   END AS "AdjLMeasBw",
  '0'::text AS "AdjLSelectFreq",
  '4'::text AS "HopLIdentifier", --par défaut je choisis un P6, BDREF corrigera avec la vraie valeur
  'ADJL_LTE2600'::text AS name
FROM 
  public."nokia_WCEL"
WHERE 
  "WCELMNC" = '01' AND --On est sur Orange
  "nokia_WCEL"."managedObject_WCEL" NOT IN --Ne fait pas partie de la liste des cellules ayant déja l'ADJL
  (
	SELECT "nokia_WCEL"."managedObject_WCEL" 
	FROM public."nokia_WCEL" INNER JOIN public."nokia_ADJL"
		ON
		"nokia_ADJL"."managedObject_distName_parent" = "nokia_WCEL"."managedObject_distName"
	WHERE "nokia_ADJL"."managedObject_ADJL" = '1'
  )
 
UNION

--ADJL 800 manquant à créer sur ORANGE (MNC=01):
SELECT 
  "nokia_WCEL".name AS "NOM",  
  "nokia_WCEL"."managedObject_WCEL",
  "managedObject_version",
  "WCELMCC",
  "WCELMNC",
  "nokia_WCEL"."managedObject_distName" || '/ADJL-2' AS "managedObject_distName",
  CASE "WCELMNC"
	WHEN '01' THEN '6400'::text --Orange
	WHEN '10' THEN '6300'::text --SFR
	WHEN '20' THEN '6200'::text --BYT
	ELSE 'ERROR' 
  END AS "AdjLEARFCN",
  CASE "WCELMNC"
	WHEN '01' THEN '50'::text --Orange
	WHEN '10' THEN '50'::text --SFR
	WHEN '20' THEN '50'::text --BYT
	ELSE 'ERROR' 
   END AS "AdjLMeasBw",
  '0'::text AS "AdjLSelectFreq",
  '5'::text AS "HopLIdentifier", --par défaut je choisis un P7, BDREF corrigera avec la vraie valeur
  'ADJL_LTE800'::text AS name
FROM 
  public."nokia_WCEL"
WHERE 
  "WCELMNC" != '15' AND --FRM n'a pas de bande de fréquence 800
  "nokia_WCEL"."managedObject_WCEL" NOT IN --Ne fait pas partie de la liste des cellules ayant déja l'ADJL
  (
	SELECT "nokia_WCEL"."managedObject_WCEL" 
	FROM public."nokia_WCEL" INNER JOIN public."nokia_ADJL"
		ON
		"nokia_ADJL"."managedObject_distName_parent" = "nokia_WCEL"."managedObject_distName"
	WHERE "nokia_ADJL"."managedObject_ADJL" = '2'
  )


UNION

--ADJL 1800 manquant à créer sur ORANGE (MNC=01):
SELECT 
  "nokia_WCEL".name AS "NOM", 
  "nokia_WCEL"."managedObject_WCEL",
  "managedObject_version",
  "WCELMCC",
  "WCELMNC",
  "nokia_WCEL"."managedObject_distName" || '/ADJL-3' AS "managedObject_distName",
  CASE "WCELMNC"
	WHEN '01' THEN '1300'::text --Orange
	WHEN '10' THEN '1500'::text --SFR
	WHEN '20' THEN '1675'::text --BYT
	WHEN '15' THEN '1850'::text --FRM
	ELSE 'ERROR' 
   END AS "AdjLEARFCN",
  CASE "WCELMNC"
	WHEN '01' THEN '50'::text --Orange
	WHEN '10' THEN '50'::text --SFR
	WHEN '20' THEN '50'::text --BYT
	WHEN '15' THEN '50'::text --FRM
	ELSE 'ERROR' 
   END AS "AdjLMeasBw",
  '0'::text AS "AdjLSelectFreq",
  '3'::text AS "HopLIdentifier", --par défaut je choisis un P5, BDREF corrigera avec la vraie valeur
  'ADJL_LTE1800'::text AS name
FROM 
  public."nokia_WCEL" 
WHERE 
  "WCELMNC" = '01' AND --On est sur Orange
  "nokia_WCEL"."managedObject_WCEL" NOT IN --Ne fait pas partie de la liste des cellules ayant déja l'ADJL
  (
	SELECT "nokia_WCEL"."managedObject_WCEL" 
	FROM public."nokia_WCEL" INNER JOIN public."nokia_ADJL"
		ON
		"nokia_ADJL"."managedObject_distName_parent" = "nokia_WCEL"."managedObject_distName"
	WHERE "nokia_ADJL"."managedObject_ADJL" = '3'
  )


UNION

--ADJL 2100 manquant à créer sur ORANGE (MNC=01):
SELECT 
  "nokia_WCEL".name AS "NOM", 
  "nokia_WCEL"."managedObject_WCEL",
  "managedObject_version",
  "WCELMCC",
  "WCELMNC",
  "nokia_WCEL"."managedObject_distName" || '/ADJL-4' AS "managedObject_distName",
  '547'::text AS "AdjLEARFCN",
  '50'::text AS "AdjLMeasBw",
  '0'::text AS "AdjLSelectFreq",
  '3'::text AS "HopLIdentifier", --par défaut je choisis un P5, BDREF corrigera avec la vraie valeur
  'ADJL_LTE2100'::text AS name
FROM 
  public."nokia_WCEL" 
WHERE 
  "WCELMNC" = '01' AND --On est sur Orange
  "nokia_WCEL"."managedObject_WCEL" NOT IN --Ne fait pas partie de la liste des cellules ayant déja l'ADJL
  (
	SELECT "nokia_WCEL"."managedObject_WCEL" 
	FROM public."nokia_WCEL" INNER JOIN public."nokia_ADJL"
		ON
		"nokia_ADJL"."managedObject_distName_parent" = "nokia_WCEL"."managedObject_distName"
	WHERE "nokia_ADJL"."managedObject_ADJL" = '4'
  )


UNION

--Cas particulier LTE800 20Mhz pour tous les RAN sharing "ADJL_LTE800_RS" EARFCN=6275 : free sur 700 ????????
SELECT 
  "nokia_WCEL".name AS "NOM", 
  "nokia_WCEL"."managedObject_WCEL",
  "managedObject_version",
  "WCELMCC",
  "WCELMNC",
  "nokia_WCEL"."managedObject_distName" || '/ADJL-5' AS "managedObject_distName",
  '6275'::text AS "AdjLEARFCN",
  '100'::text AS "AdjLMeasBw",
  '0'::text AS "AdjLSelectFreq",
  '3'::text AS "HopLIdentifier", --par défaut je choisis un P5, BDREF corrigera avec la vraie valeur
  'ADJL_LTE800_RS'::text AS name
FROM 
  public."nokia_WCEL" 
WHERE 
  ("nokia_WCEL"."managedObject_distName_parent" LIKE '%RNC-970%' OR 
  "nokia_WCEL"."managedObject_distName_parent" LIKE '%RNC-971%' ) --RNC Ransharing
   AND
  "nokia_WCEL"."managedObject_WCEL" NOT IN --Ne fait pas partie de la liste des cellules ayant déja l'ADJL
  (
	SELECT "nokia_WCEL"."managedObject_WCEL" 
	FROM public."nokia_WCEL" INNER JOIN public."nokia_ADJL"
		ON
		"nokia_ADJL"."managedObject_distName_parent" = "nokia_WCEL"."managedObject_distName"
	WHERE "nokia_ADJL"."managedObject_ADJL" = '5'
  )


ORDER BY
  "NOM",
  "managedObject_distName";


