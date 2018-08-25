--Crée une table qui liste les cellules 2100 qui doivent faire le HHO sur U900:
DROP TABLE IF EXISTS tmp_bdref_u2100_colocu900;
CREATE TABLE tmp_bdref_u2100_colocu900 AS
SELECT DISTINCT
  topo2100.name, 
  topo2100."managedObject_WCEL", 
  topo2100."BANDE"
FROM 
  public.t_topologie3g_nokia topo2100 INNER JOIN public.t_topologie3g_nokia topo900
  ON 
	topo2100."SBTSId" = topo900."SBTSId" --Pas de conf splitté sur 2 SBTS différentes
WHERE
  topo2100."BANDE" = 'U2100' AND 
  topo900."BANDE" = 'U900' AND
  topo2100."SectorID" = topo900."SectorID" AND
  topo900."AdminCellState" = '1' --U900 est allumé
ORDER BY
  topo2100.name;


DROP TABLE IF EXISTS tmp_bdref_find_tpl_targetrat;
CREATE TABLE tmp_bdref_find_tpl_targetrat AS
--Liste des cellules qui devraient pointer sur U900:
SELECT
  tmp_bdref_u2100_colocu900.name,
  tmp_bdref_u2100_colocu900."managedObject_WCEL" AS "LCID", 
  tmp_bdref_u2100_colocu900."BANDE",
  bdref_visutoporef_cell_nokia."Etat",
  bdref_visutoporef_cell_nokia."Target_Rat" AS "Actuel_Target_RAT",
  'Target_Rat'::text AS template,
  '3G_900'::text AS valeur
  
FROM
  tmp_bdref_u2100_colocu900 INNER JOIN public.bdref_visutoporef_cell_nokia
  ON
	tmp_bdref_u2100_colocu900."managedObject_WCEL" = bdref_visutoporef_cell_nokia."LCID"
WHERE
  bdref_visutoporef_cell_nokia."Target_Rat" != '3G_900'

UNION

--Liste des U2100 qui n'ont pas de U900 coloc:
SELECT 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL" AS "LCID", 
  t_topologie3g_nokia."BANDE",
    bdref_visutoporef_cell_nokia."Etat",
  bdref_visutoporef_cell_nokia."Target_Rat" AS "Actuel_Target_RAT",
  'Target_Rat'::text AS template,
  '2G'::text AS valeur
FROM 
  public.bdref_visutoporef_cell_nokia INNER JOIN public.t_topologie3g_nokia
  ON
	bdref_visutoporef_cell_nokia."LCID" = t_topologie3g_nokia."managedObject_WCEL"
  LEFT JOIN public.tmp_bdref_u2100_colocu900
  ON 
	bdref_visutoporef_cell_nokia."LCID" = tmp_bdref_u2100_colocu900."managedObject_WCEL"
WHERE 
  t_topologie3g_nokia."BANDE" = 'U2100' AND
  tmp_bdref_u2100_colocu900."managedObject_WCEL" IS NULL AND
  bdref_visutoporef_cell_nokia."Target_Rat" = '3G_900'

ORDER BY
 name;

