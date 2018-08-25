--Donne le template nb_freq en fonction du nombre de freq si on est sur fdd10
DROP TABLE IF EXISTS tmp_bdref_find_tpl_nbfreq;
CREATE TABLE tmp_bdref_find_tpl_nbfreq AS
SELECT DISTINCT
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID",
  t_topologie3g_nokia."UARFCN", 
  t_topologie3g_nokia."AdminCellState",
  t_nokiapower_freqconfig.freq_config, 
  bdref_visutoporef_cell_nokia."Nb_Freq" AS "template_nb_freq_actuel",
  'Nb_Freq'::text AS template,
  CASE 	WHEN (t_topologie3g_nokia."UARFCN" = '10787' AND t_nokiapower_freqconfig.freq_config = '10787') THEN 'FDD10_Mono'
	--On prend en compte les 10+11 :
	WHEN (t_topologie3g_nokia."UARFCN" = '10787' AND t_nokiapower_freqconfig.freq_config ='10787-10812') THEN 'FDD10_10-11'
	ELSE 'Other' END 
	AS valeur
FROM 
  public.t_topologie3g_nokia INNER JOIN public.t_nokiapower_freqconfig
  ON
    t_topologie3g_nokia."WBTS_managedObject_distName" = t_nokiapower_freqconfig."managedObject_distName_parent" AND
    t_topologie3g_nokia."SectorID" = t_nokiapower_freqconfig."SectorID" --lien par le sectorID mais ça pose un problème avec les U900 coloc dans le freqconfig
    AND t_nokiapower_freqconfig.bande = 'U2100'
  LEFT JOIN public.bdref_visutoporef_cell_nokia
  ON
    t_topologie3g_nokia."managedObject_WCEL" = bdref_visutoporef_cell_nokia."LCID"
ORDER BY 
  t_topologie3g_nokia.name;

--Liste les erreurs:
DROP TABLE IF EXISTS tmp_bdref_find_tpl_nbfreq_errors;
CREATE TABLE tmp_bdref_find_tpl_nbfreq_errors AS
SELECT 
  * 
FROM 
  public.tmp_bdref_find_tpl_nbfreq
WHERE 
  tmp_bdref_find_tpl_nbfreq.template_nb_freq_actuel != tmp_bdref_find_tpl_nbfreq.valeur;