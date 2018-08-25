DROP TABLE IF EXISTS t_nokia_wcel_crosstab_adjlhoplid;
CREATE TABLE t_nokia_wcel_crosstab_adjlhoplid AS

SELECT * FROM crosstab(
   $$
	SELECT "managedObject_distName_parent", --identifiant cellule = ligne
		"managedObject_ADJL", --pivot : numéro adjl
		"HopLIdentifier" --valeur a retrouver = colonne
		
	FROM   "nokia_ADJL"
   $$
  , 
   $$
   VALUES ('1'),('2'),('3'),('4') --Liste les valeurs possibles de row_number
   $$
   ) AS t ("WCEL_managedObject_distName" text, 
	"ADJL[1]HopLIdentifier" text, 
	"ADJL[2]HopLIdentifier" text, 
	"ADJL[3]HopLIdentifier" text, 
	"ADJL[4]HopLIdentifier" text);


DROP TABLE IF EXISTS t_nokia_wcel_crosstab_adjlmeasbw;
CREATE TABLE t_nokia_wcel_crosstab_adjlmeasbw AS

SELECT * FROM crosstab(
   $$
	SELECT "managedObject_distName_parent", --identifiant cellule = ligne
		"managedObject_ADJL", --pivot : numéro adjl
		"AdjLMeasBw" --valeur a retrouver = colonne
		
	FROM   "nokia_ADJL"
   $$
  , 
   $$
   VALUES ('1'),('2'),('3'),('4') --Liste les valeurs possibles de row_number
   $$
   ) AS t ("WCEL_managedObject_distName" text, 
	"ADJL[1]AdjLMeasBw" text, 
	"ADJL[2]AdjLMeasBw" text, 
	"ADJL[3]AdjLMeasBw" text, 
	"ADJL[4]AdjLMeasBw" text);



--creation de la table wcel param terrain resellte au format bdref:
DROP TABLE IF EXISTS t_nokia_wcel_lteparam_bdrefformat;
CREATE TABLE t_nokia_wcel_lteparam_bdrefformat AS
SELECT 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."WCEL_managedObject_distName", 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_nokia_wcel_crosstab_adjlhoplid."ADJL[1]HopLIdentifier", 
  t_nokia_wcel_crosstab_adjlhoplid."ADJL[2]HopLIdentifier", 
  t_nokia_wcel_crosstab_adjlhoplid."ADJL[3]HopLIdentifier", 
  t_nokia_wcel_crosstab_adjlhoplid."ADJL[4]HopLIdentifier", 
  t_nokia_wcel_crosstab_adjlmeasbw."ADJL[1]AdjLMeasBw", 
  t_nokia_wcel_crosstab_adjlmeasbw."ADJL[2]AdjLMeasBw", 
  t_nokia_wcel_crosstab_adjlmeasbw."ADJL[3]AdjLMeasBw", 
  t_nokia_wcel_crosstab_adjlmeasbw."ADJL[4]AdjLMeasBw"
FROM 
  public.t_topologie3g_nokia, 
  public.t_nokia_wcel_crosstab_adjlmeasbw, 
  public.t_nokia_wcel_crosstab_adjlhoplid
WHERE 
  t_topologie3g_nokia."WCEL_managedObject_distName" = t_nokia_wcel_crosstab_adjlhoplid."WCEL_managedObject_distName" AND
  t_topologie3g_nokia."WCEL_managedObject_distName" = t_nokia_wcel_crosstab_adjlmeasbw."WCEL_managedObject_distName"
ORDER BY
  name;

--resultat de la comparaison param terrain resellte au format bdref // template alloué dans bdref:
SELECT 
  t_nokia_wcel_lteparam_bdrefformat.name, 
  t_nokia_wcel_lteparam_bdrefformat."WCEL_managedObject_distName", 
  t_nokia_wcel_lteparam_bdrefformat."managedObject_WCEL", 
  bdref_template_cellule_nokia_reselection_lte."Template", 
  bdref_nokia_template_cellules."Reselection_LTE " AS "Reselection_LTE_BDREF"
FROM 
  public.t_nokia_wcel_lteparam_bdrefformat LEFT JOIN public.bdref_template_cellule_nokia_reselection_lte 
  ON
	  t_nokia_wcel_lteparam_bdrefformat."ADJL[1]HopLIdentifier" = bdref_template_cellule_nokia_reselection_lte."ADJL[1]HopLIdentifier" AND
	  t_nokia_wcel_lteparam_bdrefformat."ADJL[1]AdjLMeasBw" = bdref_template_cellule_nokia_reselection_lte."ADJL[1]AdjLMeasBw" AND
	  t_nokia_wcel_lteparam_bdrefformat."ADJL[2]AdjLMeasBw" = bdref_template_cellule_nokia_reselection_lte."ADJL[2]AdjLMeasBw" AND
	  t_nokia_wcel_lteparam_bdrefformat."ADJL[3]AdjLMeasBw" = bdref_template_cellule_nokia_reselection_lte."ADJL[3]AdjLMeasBw" AND
	  t_nokia_wcel_lteparam_bdrefformat."ADJL[2]HopLIdentifier" = bdref_template_cellule_nokia_reselection_lte."ADJL[2]HopLIdentifier" AND
	  t_nokia_wcel_lteparam_bdrefformat."ADJL[3]HopLIdentifier" = bdref_template_cellule_nokia_reselection_lte."ADJL[3]HopLIdentifier"
  
  INNER JOIN public.bdref_nokia_template_cellules
  ON
     t_nokia_wcel_lteparam_bdrefformat."managedObject_WCEL" = bdref_nokia_template_cellules."LCID"
WHERE
  bdref_template_cellule_nokia_reselection_lte."Template" != bdref_nokia_template_cellules."Reselection_LTE " OR
  bdref_template_cellule_nokia_reselection_lte."Template" IS NULL OR 
  bdref_nokia_template_cellules."Reselection_LTE " IS NULL
  
ORDER BY 
  t_nokia_wcel_lteparam_bdrefformat.name;
