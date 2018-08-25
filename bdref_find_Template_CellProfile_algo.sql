--On utilise la table t_nokiapower_freqconfig qui donne les freq_config u2100 sur le terrain: créée daans un sql précédent

--REQUETE PRINCIPALE: Donne la valeur théorique de classe pour chaque cellule en fonction du freqConfig
DROP TABLE IF EXISTS t_bdref3g_check_nokia_cellprofile;
CREATE TABLE t_bdref3g_check_nokia_cellprofile AS
SELECT 
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID", 
  t_topologie3g_nokia."AdminCellState", 
  t_topologie3g_nokia."WCelState",
  t_topologie3g_nokia."SectorID",
  t_topologie3g_nokia."UARFCN", 
  t_topologie3g_nokia."BANDE",
  bdref_visutoporef_cell_nokia."CLASSE" AS "classe_actuelle",
  bdref_visutoporef_cell_nokia."CellProfile" AS "CellProfile_actuel",
  bdref_visutoporef_cell_nokia."Etat",
  freq_config,
  topo900.name AS "U900_name",
  topo900."AdminCellState" AS "U900_AdminCellState",
  'CellProfile'::text AS template,
  CASE 
	--Cas LTE2100 en cours de construction:
	WHEN t_topologie3g_nokia."UARFCN" = '10712' AND freq_config NOT LIKE '%10712%' AND t_topologie3g_nokia."AdminCellState" = '0' THEN 'Default'
	--Classique:
	WHEN t_topologie3g_nokia."UARFCN" = '10787' AND freq_config IN ('10787','10787-10812','10787-10812-10836','10712-10787-10812-10836') THEN
		CASE 
			WHEN topo900."AdminCellState" = '1' THEN 'FDD10_colocU900'
			ELSE 'Default'
		END
	
	WHEN t_topologie3g_nokia."UARFCN" = '10812' THEN 'Default'
	WHEN t_topologie3g_nokia."UARFCN" = '10836' THEN 'Default'
	WHEN t_topologie3g_nokia."UARFCN" = '10712' AND freq_config = '10712-10787-10812-10836' THEN 'Default' --fdd7 classique
	--coloc L2100:
	WHEN t_topologie3g_nokia."UARFCN" = '10787' AND freq_config = '10712-10787' THEN 'Default'
	WHEN t_topologie3g_nokia."UARFCN" = '10712' AND freq_config IN ('10712-10787','10712') THEN 'Default' --on prend en compte les mono fdd7
	
	ELSE 'ERROR'::text
	END AS "valeur"

FROM public.t_topologie3g_nokia LEFT JOIN t_nokiapower_freqconfig
  ON
    t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokiapower_freqconfig."managedObject_distName_parent" AND
    t_topologie3g_nokia."SectorID" = t_nokiapower_freqconfig."SectorID" AND
    t_topologie3g_nokia."BANDE" = t_nokiapower_freqconfig.bande
  LEFT JOIN public.bdref_visutoporef_cell_nokia
  ON
	t_topologie3g_nokia."managedObject_WCEL" = bdref_visutoporef_cell_nokia."LCID"
  LEFT JOIN public.t_topologie3g_nokia AS topo900
  ON
	t_topologie3g_nokia."WBTS_managedObject_distName" = topo900."WBTS_managedObject_distName" AND
	t_topologie3g_nokia."SectorID" = topo900."SectorID" AND
	t_topologie3g_nokia."BANDE" != topo900."BANDE" --On cherche les bandes différentes
WHERE 
  t_topologie3g_nokia."managedObject_WCEL" NOT IN --Supprime les celules encore ALU
  (
	SELECT 
	  snap3g_fddcell.localcellid
	FROM 
	  public.snap3g_fddcell 
  )
  AND t_topologie3g_nokia."WBTS_managedObject_distName" NOT LIKE '%EXCCU%' --exclut les external
  AND t_topologie3g_nokia."BANDE" = 'U2100'

UNION --Ajout des U900

SELECT 
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID", 
  t_topologie3g_nokia."AdminCellState", 
  t_topologie3g_nokia."WCelState",
  t_topologie3g_nokia."SectorID",
  t_topologie3g_nokia."UARFCN", 
  t_topologie3g_nokia."BANDE",
  bdref_visutoporef_cell_nokia."CLASSE" AS "classe_actuelle",
  bdref_visutoporef_cell_nokia."CellProfile" AS "CellProfile_actuel",
  bdref_visutoporef_cell_nokia."Etat",
  freq_config,
  ''::text AS "U900_name",
  ''::text AS "U900_AdminCellState",
  'CellProfile'::text AS template,
  CASE 
	--Cas U900 Urbain:
	WHEN bdref_visutoporef_cell_nokia."CLASSE" = 'Nokia_FDD900_Urbain' THEN 'Default'
	--U900 Rural:
	WHEN bdref_visutoporef_cell_nokia."CLASSE" = 'Nokia_FDD900_Rural' THEN 'Default'
	WHEN bdref_visutoporef_cell_nokia."CLASSE" LIKE 'Nokia_RS%' THEN 'Default'
	ELSE 'ERROR'::text
	END AS "valeur"

FROM public.t_topologie3g_nokia LEFT JOIN t_nokiapower_freqconfig
  ON
    t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokiapower_freqconfig."managedObject_distName_parent" AND
    t_topologie3g_nokia."SectorID" = t_nokiapower_freqconfig."SectorID" AND
    t_topologie3g_nokia."BANDE" = t_nokiapower_freqconfig.bande
  LEFT JOIN public.bdref_visutoporef_cell_nokia
  ON
	t_topologie3g_nokia."managedObject_WCEL" = bdref_visutoporef_cell_nokia."LCID"
  
WHERE 
  t_topologie3g_nokia."managedObject_WCEL" NOT IN --Supprime les celules encore ALU
  (
	SELECT 
	  snap3g_fddcell.localcellid
	FROM 
	  public.snap3g_fddcell 
  )
  AND t_topologie3g_nokia."WBTS_managedObject_distName" NOT LIKE '%EXCCU%' --exclut les external
  AND t_topologie3g_nokia."BANDE" = 'U900'


ORDER BY
  name;


--Liste les erreurs:
DROP TABLE IF EXISTS t_bdref3g_check_nokia_cellprofile_errors;
CREATE TABLE t_bdref3g_check_nokia_cellprofile_errors AS
SELECT 
  * 
FROM 
  public.t_bdref3g_check_nokia_cellprofile
WHERE 
  t_bdref3g_check_nokia_cellprofile."CellProfile_actuel" != t_bdref3g_check_nokia_cellprofile.valeur;
 
;
