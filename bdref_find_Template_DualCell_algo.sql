--Donne le template nb_freq en fonction du nombre de freq si on est sur fdd10
DROP TABLE IF EXISTS tmp_bdref_find_tpl_dualcell;
CREATE TABLE tmp_bdref_find_tpl_dualcell AS
SELECT DISTINCT
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID",
  t_topologie3g_nokia."UARFCN", 
  t_topologie3g_nokia."AdminCellState",
  bdref_visutoporef_cell_nokia."Etat",
  t_nokiapower_freqconfig.freq_config, 
  bdref_visutoporef_cell_nokia."DualCell" AS "template_dualcell_actuel",
  'DualCell'::text AS template,
  CASE 	WHEN (t_topologie3g_nokia."UARFCN" = '10787' AND t_nokiapower_freqconfig.freq_config = '10787-10812') THEN 'Dual_Cell'
	WHEN (t_topologie3g_nokia."UARFCN" IN ('10812','10836')) THEN 'Dual_Cell'
	ELSE 'No_Dual_Cell' END 
	AS valeur
FROM 
  public.t_topologie3g_nokia INNER JOIN public.t_nokiapower_freqconfig
  ON
    t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokiapower_freqconfig."managedObject_distName_parent" AND
    t_topologie3g_nokia."SectorID" = t_nokiapower_freqconfig."SectorID" AND
    t_topologie3g_nokia."BANDE" = t_nokiapower_freqconfig.bande
  LEFT JOIN public.bdref_visutoporef_cell_nokia
  ON
    t_topologie3g_nokia."managedObject_WCEL" = bdref_visutoporef_cell_nokia."LCID"
ORDER BY 
  t_topologie3g_nokia.name;

--Liste les erreurs:
DROP TABLE IF EXISTS tmp_bdref_find_tpl_dualcell_errors;
CREATE TABLE tmp_bdref_find_tpl_dualcell_errors AS
SELECT 
  * 
FROM 
  public.tmp_bdref_find_tpl_dualcell
WHERE 
  "template_dualcell_actuel" != valeur;