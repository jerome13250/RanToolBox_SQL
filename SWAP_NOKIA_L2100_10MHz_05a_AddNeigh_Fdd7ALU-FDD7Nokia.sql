--Creation de la table de voisines FDD10-FDD10 vision OMC terrain
DROP TABLE IF EXISTS t_voisnokia_intra_fdd10_distance;
CREATE TABLE t_voisnokia_intra_fdd10_distance AS
SELECT 
  t_voisines3g3g.fddcell AS name_s, 
  t_voisines3g3g.localcellid_s  AS "LCIDS", 
  t_voisines3g3g.dlfrequencynumber_s AS "UARFCN_s",
  t_voisines3g3g.umtsfddneighbouringcell AS name_v, 
  t_voisines3g3g.localcellid_v AS "LCIDV", 
  t_voisines3g3g.dlfrequencynumber_v AS "UARFCN_v",
  round(cast(|/( (topo1."X"::int-topo2."X"::int) ^ 2 + (topo1."Y"::int-topo2."Y"::int) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_voisines3g3g INNER JOIN public.t_noria_topo_3g AS topo1
  ON 
	t_voisines3g3g.localcellid_s = topo1."IDRESEAUCELLULE"
  INNER JOIN public.t_noria_topo_3g AS topo2
  ON
	t_voisines3g3g.localcellid_v = topo2."IDRESEAUCELLULE"
WHERE
  t_voisines3g3g.dlfrequencynumber_s = '10787' AND
  t_voisines3g3g.dlfrequencynumber_v = '10787'

UNION --On rajoute ALU

SELECT DISTINCT
  t_voisines3g3g_nokia_intra.name_s, 
  t_voisines3g3g_nokia_intra."WCEL_managedObject_distName" AS "LCIDS", 
  t_voisines3g3g_nokia_intra."UARFCN_s", 
  t_voisines3g3g_nokia_intra.adjs_name AS name_v, 
  t_voisines3g3g_nokia_intra."LCIDV",
  '10787'::text AS "UARFCN_v", --forcément vu qu'on est sur un ADJS
  round(cast(|/( (topo1."X"::int-topo2."X"::int) ^ 2 + (topo1."Y"::int-topo2."Y"::int) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_voisines3g3g_nokia_intra INNER JOIN public.t_noria_topo_3g AS topo1
  ON 
	t_voisines3g3g_nokia_intra."LCIDS" = topo1."IDRESEAUCELLULE"
  INNER JOIN public.t_noria_topo_3g AS topo2
  ON
	t_voisines3g3g_nokia_intra."LCIDV" = topo2."IDRESEAUCELLULE"
WHERE 
   "UARFCN_s" = '10787' AND
   t_voisines3g3g_nokia_intra."WCEL_managedObject_distName" NOT IN ( --suppression des cellules qui existent en avance de phase sur OMC Nokia, toujours ALU
	SELECT localcellid
	FROM public.snap3g_fddcell)
;


--creation de la table des priorites avec ranking des voisines:
DROP TABLE IF EXISTS t_voisnokia_intra_fdd10_ranked;
CREATE TABLE t_voisnokia_intra_fdd10_ranked AS
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY "LCIDS" ORDER BY distance_km ASC, name_v ASC) AS ranking
FROM 
  public.t_voisnokia_intra_fdd10_distance
ORDER BY
  name_s,
  ranking;

--Creation de la table de mapping FDD10-FDD7
-- ATTENTION EN FRONTIERE d'UR IL VA MANQUER LES VOISINES
DROP TABLE IF EXISTS t_voisnokia_mapping_fdd10_fdd7;
CREATE TABLE t_voisnokia_mapping_fdd10_fdd7 AS

SELECT 
  fddcell_s.fddcell AS name_fdd10, 
  fddcell_s.localcellid AS "LCID_fdd10", 
  fddcell_s.dlfrequencynumber AS "UARFCN_fdd10", 
  fddcell_v.fddcell AS name_fdd7, 
  fddcell_v.localcellid AS "LCID_fdd7", 
  fddcell_v.dlfrequencynumber AS "UARFCN_fdd7"
FROM 
  public.snap3g_fddcell fddcell_s INNER JOIN public.snap3g_fddcell fddcell_v
  ON
	fddcell_s.nodeb = fddcell_v.nodeb
WHERE
  fddcell_s.dlfrequencynumber = '10787' AND
  fddcell_v.dlfrequencynumber = '10712' AND
  left(right(fddcell_s.fddcell,2),1) = left(right(fddcell_v.fddcell,2),1)

UNION

SELECT 
  "WCEL_s".name, 
  "WCEL_s"."managedObject_WCEL", 
  "WCEL_s"."UARFCN", 
  "WCEL_v".name, 
  "WCEL_v"."managedObject_WCEL", 
  "WCEL_v"."UARFCN"
FROM 
  public."nokia_WCEL" "WCEL_s" INNER JOIN public."nokia_WCEL" "WCEL_v"
  ON 
	"WCEL_s"."managedObject_distName_parent" = "WCEL_v"."managedObject_distName_parent"
WHERE
  "WCEL_s"."UARFCN" = '10787' AND
  "WCEL_v"."UARFCN" = '10712' AND
  left(right("WCEL_s".name,2),1) = left(right("WCEL_v".name,2),1) AND
  "WCEL_s"."managedObject_WCEL" NOT IN ( --suppression des cellules qui existent en avance de phase sur OMC Nokia, toujours ALU
	SELECT localcellid
	FROM public.snap3g_fddcell)
;
 
--Ajout dans le mapping fdd10-fdd7 des nouvelles cellules fdd7 nokia apres swap:
INSERT INTO t_voisnokia_mapping_fdd10_fdd7
  SELECT 
  action1.fddcell AS name_fdd10, 
  action1.localcellid AS "LCID_fdd10",
  action1.dlfrequencynumber AS "UARFCN_fdd10",
  left(action2.fddcell,-1) || '4' AS name_fdd7, --donne le futur nom
  action2.localcellid AS "LCID_fdd7", --reutilise un lcid existant
  '10712'::text AS "UARFCN_fdd7" --donne la future freq
FROM 
  public.t_swap_l2100_10mhz_action action1, 
  public.t_swap_l2100_10mhz_action action2
WHERE 
  action1.nodeb = action2.nodeb AND
  action1.dlfrequencynumber = '10787' AND 
  action2.dlfrequencynumber = '10812' AND --on ne rajoute que les cas de fdd7 shifté depuis fdd11
  left(right(action1.fddcell,2),1) = left(right(action2.fddcell,2),1); --isosecteur

--creation du plan de voisines ALU fdd7-fdd7 cloné depuis fdd10-fdd10:
DROP TABLE IF EXISTS t_voisnokia_fdd7alu_cloneplan;
CREATE TABLE t_voisnokia_fdd7alu_cloneplan AS
SELECT 
  mapping1.name_fdd7 AS name_s, 
  mapping1."LCID_fdd7" AS "LCIDS", 
  mapping1."UARFCN_fdd7" AS "UARFCN_s", 
  mapping2.name_fdd7 AS name_v, 
  mapping2."LCID_fdd7" AS "LCIDV", 
  mapping2."UARFCN_fdd7" AS "UARFCN_v", 
  t_voisnokia_intra_fdd10_ranked.ranking, 
  t_voisnokia_intra_fdd10_ranked.distance_km
FROM 
  public.t_voisnokia_intra_fdd10_ranked, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping1, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping2
WHERE 
  t_voisnokia_intra_fdd10_ranked."LCIDS" = mapping1."LCID_fdd10" AND
  t_voisnokia_intra_fdd10_ranked."LCIDV" = mapping2."LCID_fdd10" AND
  t_voisnokia_intra_fdd10_ranked.ranking <= 25;

--Liste les voisines fdd7 Alu vers Nokia a créer:
DROP TABLE IF EXISTS t_swap_l2100_10mhz_voisAlufdd7;
CREATE TABLE t_swap_l2100_10mhz_voisAlufdd7 AS
SELECT 
  t_voisnokia_fdd7alu_cloneplan.name_s AS "NOMs", 
  t_voisnokia_fdd7alu_cloneplan."LCIDS" AS "LCIDs", 
  t_voisnokia_fdd7alu_cloneplan."UARFCN_s", 
  t_voisnokia_fdd7alu_cloneplan.name_v AS "NOMv", 
  t_voisnokia_fdd7alu_cloneplan."LCIDV" AS "LCIDv", 
  t_voisnokia_fdd7alu_cloneplan."UARFCN_v", 
  t_voisnokia_fdd7alu_cloneplan.ranking, 
  t_voisnokia_fdd7alu_cloneplan.distance_km,
  'A'::text AS "Opération"
FROM 
  public.t_voisnokia_fdd7alu_cloneplan INNER JOIN public.t_swap_l2100_10mhz_action AS listswap1
  ON
	t_voisnokia_fdd7alu_cloneplan."LCIDV" = listswap1.localcellid 
  LEFT JOIN public.t_swap_l2100_10mhz_action AS listswap2
  ON
	t_voisnokia_fdd7alu_cloneplan."LCIDS" = listswap2.localcellid
WHERE
  listswap1.action = 'future_fdd7' AND --on restreint aux cellules fdd11 qui deviennent fdd7
  listswap2.localcellid IS NULL; --pas de changement sur les cellules swappées car elles sont sous resp. nokia


