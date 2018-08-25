DROP TABLE IF EXISTS tmp_remotefddcell_nameNotLikeNokia;
CREATE TABLE tmp_remotefddcell_nameNotLikeNokia AS

SELECT
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.umtsneighbouring, 
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.localcellid,
  t_topologie3g_nokia."AdminCellState", 
  t_topologie3g_nokia."WCelState",
  t_topologie3g_nokia."name"
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  LEFT JOIN snap3g_fddcell
  ON
	snap3g_remotefddcell.localcellid = snap3g_fddcell.localcellid
WHERE 
  snap3g_fddcell.localcellid IS NULL AND --le lcid n'existe pas dans l'omc ALU donc il peut exister sur NOKIA
  snap3g_remotefddcell.remotefddcell != t_topologie3g_nokia."name" --le nom est different entre alu remote et nokia wcel
  AND t_topologie3g_nokia."WBTS_managedObject_distName" != 'PLMN-PLMN/EXCCU-1' -- La cellule est interne au réseau NOKIA
  --AND snap3g_remotefddcell.remotefddcell NOT LIKE '%VIOUGUES%' --temporaire
  --AND snap3g_remotefddcell.remotefddcell NOT LIKE '%GENERAL_SARRAI%' --temporaire
ORDER BY
remotefddcell
;