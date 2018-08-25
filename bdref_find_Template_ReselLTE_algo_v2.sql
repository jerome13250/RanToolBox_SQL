/*cet algo sert a definir les priorites de reselection lte, on compare les codes nidt de l'omc nokia
pour savoir quels sont les bandes lte coloc allumées*/

--Crée la table des fréquences LTE présentes par GN:
DROP TABLE IF EXISTS tmp_noria_enodeb_mapping_GN_step1;
CREATE TABLE tmp_noria_enodeb_mapping_GN_step1 AS
SELECT
  "sbtsDescription", --donne le code GN du site LTE
  "earfcnDL", 
  "dlChBw",
  --"dlRsBoost",
  --MIN(qrxlevmin) AS qrxlevmin,
  MIN("administrativeState") AS "administrativeState", -- 1: unlocked / 2: shutting down / 3: locked
  CASE	WHEN "earfcnDL" = '1300' THEN '1800'::text
	WHEN "earfcnDL" = '3000' THEN '2600'::text
	WHEN "earfcnDL" = '6400' THEN '800'::text
	WHEN "earfcnDL" = '547' THEN '2100'::text
	ELSE 'UNKNOWN_FREQ-'::text || "earfcnDL"  END 
	AS bande,
CASE	
	WHEN "earfcnDL" = '547' THEN '4'::text --2100 prio 4
	WHEN "earfcnDL" = '6400' THEN '3'::text --800 prio 3
	WHEN "earfcnDL" = '1300' THEN '2'::text --1800 prio 2
	WHEN "earfcnDL" = '3000' THEN '1'::text --2600 prio 1
	ELSE 'ERROR'::text END 
	AS default_prio
FROM 
  public.t_topologie4g_nokia  --A FAIRE : verifier si les cellules MRBTS sont présentes
WHERE
  "administrativeState" = '1' --Au final l'administrativeState ne doit être que =1, A FAIRE : Simplifier les requetes suivantes
GROUP BY
  "sbtsDescription", 
  "earfcnDL", 
  "dlChBw"
  --"dlRsBoost", 

ORDER BY
  "sbtsDescription"
;

--calcul des vraies priorites en fonction de l'administrativestate puis de la default_priority grace aux windowing sql functions:
--INUTILE CAR on a filtré sur "administrativeState" = '1'
DROP TABLE IF EXISTS tmp_noria_enodeb_mapping_GN_step2;
CREATE TABLE tmp_noria_enodeb_mapping_GN_step2 AS
SELECT 
  tmp_noria_enodeb_mapping_gn_step1.*,
  row_number() OVER (PARTITION BY "sbtsDescription" --on definit la prio sur chaque nidt different
			ORDER BY "administrativeState" ASC, --1: unlocked / 2: shutting down / 3: locked donc ASC
			default_prio ASC --prio1 2600 > prio2 1800 > prio3 800
		) as row_number
FROM 
  public.tmp_noria_enodeb_mapping_gn_step1;

--Definit les templates en fonction de la frequence prioritaire presente:
DROP TABLE IF EXISTS tmp_noria_enodeb_mapping_GN_step3;
CREATE TABLE tmp_noria_enodeb_mapping_GN_step3 AS
SELECT 
  tmp_noria_enodeb_mapping_gn_step2.*,
  CASE	WHEN bande = '800' THEN '800/2600/1800/2100'::text
	WHEN bande = '2600' THEN '2600/800/1800/2100'::text
	WHEN bande = '1800' THEN '1800/2600/800/2100'::text
	WHEN bande = '2100' THEN '2100/2600/1800/800'::text
	ELSE 'ERROR '::text || bande END 
  AS templateu2100_reselection_lte,
  '800/2600/1800/2100'::text AS templateu900_reselection_lte
FROM 
  public.tmp_noria_enodeb_mapping_gn_step2
WHERE
  row_number = 1; --seule la priorité maximale définit la configuration

  
 /* OBSOLETE :
--Modifie la table step3 avec les valeurs speciales de dlChBw pour le 1800: plus simple à faire que de multiplier les cas dans les requetes précédentes

UPDATE tmp_noria_enodeb_mapping_gn_step3 AS t3
  SET 
  templateu2100_reselection_lte = 
	  CASE	WHEN t1."dlChBw" = '200' THEN replace(t3.templateu2100_reselection_lte,'1800','1800-20MHz')
		WHEN t1."dlChBw" = '150' THEN replace(t3.templateu2100_reselection_lte,'1800','1800-15MHz')
		ELSE 'ERROR'::text END,
  templateu900_reselection_lte =	
	  CASE	WHEN t1."dlChBw" = '200' THEN replace(t3.templateu900_reselection_lte,'1800','1800-20MHz')
		WHEN t1."dlChBw" = '150' THEN replace(t3.templateu900_reselection_lte,'1800','1800-15MHz')
		ELSE 'ERROR'::text END
FROM public.tmp_noria_enodeb_mapping_gn_step1 AS t1
WHERE
  t3."sbtsDescription" = t1."sbtsDescription" AND
  t1.bande = '1800' AND
  t1."dlChBw" IN ('200','150') --filtre sur les cas particuliers 1800
;

*/


--Allocation des templates aux cellules UMTS:
DROP TABLE IF EXISTS tmp_bdref_find_tpl_resellte;
CREATE TABLE tmp_bdref_find_tpl_resellte AS
SELECT DISTINCT
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia.name,
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID", 
  t_topologie3g_nokia."UARFCN",
  t_topologie3g_nokia."BTSAdditionalInfo",
  bdref_visutoporef_cell_nokia."CLASSE",
  bdref_visutoporef_cell_nokia."Reselection_LTE" AS template_resellte_actuel_bdref, 
  'Reselection_LTE'::text AS template,
  CASE	WHEN "CLASSE" LIKE 'Nokia_RS%' THEN 'Default'::text
	WHEN "UARFCN" = '3011' THEN '800/2600/1800/2100'::text --dans tous les cas 800 en premier
	ELSE COALESCE(templateu2100_reselection_lte, '800/2600/1800/2100'::text) END --si pas de correspondance, valeur par defaut
  AS valeur,
  CASE 	WHEN "CLASSE" LIKE 'Nokia_RS%' THEN 'parametrage de classe'::text
	WHEN templateu2100_reselection_lte IS NULL THEN 'No coloc value'::text 
	ELSE 'Coloc LTE value' END AS commentaire
  
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.tmp_noria_enodeb_mapping_gn_step3
  ON 
     t_topologie3g_nokia."BTSAdditionalInfo" = tmp_noria_enodeb_mapping_gn_step3."sbtsDescription"  --PROBLEME : Il y  des noms avec "underscore"
  LEFT JOIN public.bdref_visutoporef_cell_nokia
  ON
     t_topologie3g_nokia."managedObject_WCEL" = bdref_visutoporef_cell_nokia."LCID"
  
WHERE
  "WBTS_managedObject_distName" NOT LIKE 'PLMN-PLMN/EXCCU%' 
  --AND   "Reselection_LTE " IS NULL
ORDER BY 
  t_topologie3g_nokia.name;

--Reste a faire les modifications sur le 800 en zone deboost


--Allocation des templates aux cellules UMTS:
DROP TABLE IF EXISTS tmp_bdref_find_tpl_resellte_errors;
CREATE TABLE tmp_bdref_find_tpl_resellte_errors AS
SELECT 
  * 
FROM 
  public.tmp_bdref_find_tpl_resellte
WHERE 
  replace(tmp_bdref_find_tpl_resellte.template_resellte_actuel_bdref,'-deboost','') != tmp_bdref_find_tpl_resellte.valeur;














