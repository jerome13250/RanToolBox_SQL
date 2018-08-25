--Donne les freq_config u2100 sur le terrain:
DROP TABLE IF EXISTS t_nokiapower_freqconfig;
CREATE TABLE t_nokiapower_freqconfig AS
SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID",
  'U2100'::text AS bande, 
  string_agg("nokia_WCEL"."UARFCN", '-' ORDER BY "nokia_WCEL"."UARFCN") AS freq_config
FROM 
  public."nokia_WCEL"
WHERE
  "UARFCN"::int > 10000
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID"

UNION --Liste les freq_config U900:

SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID",
  'U900'::text AS bande, 
  string_agg("nokia_WCEL"."UARFCN", '-' ORDER BY "nokia_WCEL"."UARFCN") AS freq_config
  --COUNT("nokia_WCEL"."UARFCN")
FROM 
  public."nokia_WCEL"
WHERE
  "UARFCN"::int < 10000
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID";

--REQUETE PRINCIPALE: Donne la valeur théorique de classe pour chaque cellule en fonction du freqConfig
DROP TABLE IF EXISTS t_bdref3g_check_nokia_classe;
CREATE TABLE t_bdref3g_check_nokia_classe AS
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
  bdref_t_topologie."Classe" AS "classe_actuelle",
  freq_config,
  CASE 
	--Cas LTE2100 en cours:
	WHEN t_topologie3g_nokia."UARFCN" = '10712' AND freq_config != '10712-10787' AND "AdminCellState" = '0' THEN 'Extension en cours'

	--Classique:
	WHEN t_topologie3g_nokia."UARFCN" = '10787' AND freq_config IN ('10787','10787-10812','10787-10812-10836','10712-10787-10812-10836') THEN 'Nokia_FDD10'
	WHEN t_topologie3g_nokia."UARFCN" = '10812' THEN 'Nokia_FDD11'
	WHEN t_topologie3g_nokia."UARFCN" = '10836' THEN 'Nokia_FDD12'
	WHEN t_topologie3g_nokia."UARFCN" = '10712' AND freq_config = '10712-10787-10812-10836' THEN 'Nokia_FDD7' --fdd7 classique
	--coloc L2100:
	WHEN t_topologie3g_nokia."UARFCN" = '10787' AND freq_config = '10712-10787' THEN 'Nokia_FDD10_colocL2100'
	WHEN t_topologie3g_nokia."UARFCN" = '10712' AND freq_config = '10712-10787' THEN 'Nokia_FDD7_colocL2100'
	

	--U900:
	WHEN t_topologie3g_nokia."UARFCN" = '3011' THEN 'Nokia_FDD900_Urbain'
	ELSE 'undefined'::text
	END AS "classe"

FROM public.t_topologie3g_nokia LEFT JOIN t_nokiapower_freqconfig
  ON
    t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokiapower_freqconfig."managedObject_distName_parent" AND
    t_topologie3g_nokia."SectorID" = t_nokiapower_freqconfig."SectorID" AND
    t_topologie3g_nokia."BANDE" = t_nokiapower_freqconfig.bande
  LEFT JOIN public.bdref_t_topologie
  ON
	t_topologie3g_nokia."managedObject_WCEL" = bdref_t_topologie."LCID"
WHERE 
  t_topologie3g_nokia."managedObject_WCEL" NOT IN --Supprime les celules encore ALU
  (
	SELECT 
	  snap3g_fddcell.localcellid
	FROM 
	  public.snap3g_fddcell 
  )
ORDER BY
  t_topologie3g_nokia.name
  
;
