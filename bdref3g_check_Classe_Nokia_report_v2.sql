--REQUETE PRINCIPALE: Donne la valeur théorique de classe pour chaque cellule en fonction du freqConfig
--La v2 prend en compte la table bdref_visutoporef_cell_nokia au lieu de bdref_visutoporef_cell_nokia
DROP TABLE IF EXISTS t_bdref3g_check_nokia_classe;
CREATE TABLE t_bdref3g_check_nokia_classe AS
SELECT 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID", 
  t_topologie3g_nokia."AdminCellState", 
  t_topologie3g_nokia."WCelState",
  t_topologie3g_nokia."SectorID",
  t_topologie3g_nokia."UARFCN", 
  t_topologie3g_nokia."BANDE",
  
  bdref_visutoporef_cell_nokia."CLASSE" AS "classe_actuelle",
  bdref_visutoporef_cell_nokia."Etat",
  freq_config,
  CASE
	WHEN "RNCName" LIKE 'RS\_%' THEN
	    CASE
		WHEN t_topologie3g_nokia."UARFCN" = '3011' THEN 'Nokia_RS_OFR_FDD900'
		WHEN t_topologie3g_nokia."UARFCN" = '3037' THEN 'Nokia_RS_FRM_FDD900'
		WHEN t_topologie3g_nokia."UARFCN" = '2950' THEN 'Nokia_RS_BYT_FDD900'
		WHEN t_topologie3g_nokia."UARFCN" = '3075' THEN 'Nokia_RS_SFR_FDD900'
		ELSE 'undefined'::text
	    END
	ELSE
	    CASE 
		--Cas LTE2100 en cours:
		WHEN t_topologie3g_nokia."UARFCN" = '10712' AND freq_config NOT LIKE '10712%' THEN 'Nokia_FDD7_colocL2100' --fdd7 en cours de construction
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
	    END
	END AS "classe"

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
  AND t_topologie3g_nokia."WBTS_managedObject_distName" NOT LIKE '%EXCCU%'
ORDER BY
  t_topologie3g_nokia.name
  
;


DROP TABLE IF EXISTS t_bdref3g_check_nokia_classe_errors;
CREATE TABLE t_bdref3g_check_nokia_classe_errors AS
SELECT *
FROM t_bdref3g_check_nokia_classe
WHERE
"classe_actuelle" != "classe" AND 
NOT ("classe_actuelle" LIKE 'Nokia_FDD900%' AND "classe" LIKE 'Nokia_FDD900%') AND --Ce cas n'est pas une erreur, on peut avoir Rural ou urbain
NOT ("classe_actuelle" = 'Nokia_FDD10_hotSpot' AND "classe" LIKE 'Nokia_FDD10') AND
NOT ("classe_actuelle" = 'Nokia_FDD11_hotSpot' AND "classe" LIKE 'Nokia_FDD11') AND
NOT ("classe_actuelle" = 'Nokia_FDD12_hotSpot' AND "classe" LIKE 'Nokia_FDD12')

;





