--Creation de la table de voisines FDD10-FDD10 et FDD10-FDD900 vision OMC
--Cela servira à créer le plan de voisine théorique de fdd7-fdd7, fdd7-fdd10 et fdd7-fdd900

DROP TABLE IF EXISTS t_vois_xfreql2100_01_planfdd10;
CREATE TABLE t_vois_xfreql2100_01_planfdd10 AS
SELECT 
  t_voisines3g3g.fddcell AS name_s, 
  t_voisines3g3g.localcellid_s  AS "LCIDS", 
  t_voisines3g3g.dlfrequencynumber_s AS "UARFCN_s",
  topo1."GN" AS "GN_s",
  t_voisines3g3g.umtsfddneighbouringcell AS name_v, 
  t_voisines3g3g.localcellid_v AS "LCIDV", 
  t_voisines3g3g.dlfrequencynumber_v AS "UARFCN_v",
  topo2."GN" AS "GN_v",
  round(cast(|/( (topo1."X"::int-topo2."X"::int) ^ 2 + (topo1."Y"::int-topo2."Y"::int) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_voisines3g3g INNER JOIN public.t_vois_xfreql2100_00_topo AS topo1
  ON 
	t_voisines3g3g.localcellid_s = topo1.localcellid
  INNER JOIN public.t_vois_xfreql2100_00_topo AS topo2
  ON
	t_voisines3g3g.localcellid_v = topo2.localcellid
WHERE
  t_voisines3g3g.dlfrequencynumber_s = '10787' AND
  t_voisines3g3g.dlfrequencynumber_v IN ('10787','3011') --liste les voisines fdd10-fdd10 et fdd10-fdd9000

UNION --On rajoute NOKIA FDD10-FDD10:

SELECT DISTINCT
  t_voisines3g3g_nokia_intra.name_s, 
  t_voisines3g3g_nokia_intra."LCIDS" AS "LCIDS", 
  t_voisines3g3g_nokia_intra."UARFCN_s",
  topo1."GN" AS "GN_s",
  t_voisines3g3g_nokia_intra.adjs_name AS name_v, 
  t_voisines3g3g_nokia_intra."LCIDV",
  '10787'::text AS "UARFCN_v", --forcément vu qu'on est sur un ADJS
  topo2."GN" AS "GN_v",
  round(cast(|/( (topo1."X"::int-topo2."X"::int) ^ 2 + (topo1."Y"::int-topo2."Y"::int) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_voisines3g3g_nokia_intra INNER JOIN public.t_vois_xfreql2100_00_topo AS topo1
  ON 
	t_voisines3g3g_nokia_intra."LCIDS" = topo1.localcellid
  INNER JOIN public.t_vois_xfreql2100_00_topo AS topo2
  ON
	t_voisines3g3g_nokia_intra."LCIDV" = topo2.localcellid
WHERE 
   "UARFCN_s" = '10787' AND
   t_voisines3g3g_nokia_intra."WCEL_managedObject_distName" NOT IN ( --suppression des cellules qui existent en avance de phase sur OMC Nokia, toujours ALU
	SELECT localcellid
	FROM public.snap3g_fddcell)

UNION --On rajoute NOKIA FDD10-FDD900:

SELECT DISTINCT
  t_voisines3g3g_nokia_inter.name_s, 
  t_voisines3g3g_nokia_inter."managedObject_WCEL" AS "LCIDS", 
  t_voisines3g3g_nokia_inter."UARFCN_s",
  topo1."GN" AS "GN_s", 
  t_voisines3g3g_nokia_inter.adji_name AS name_v, 
  t_voisines3g3g_nokia_inter."LCIDV",
  t_voisines3g3g_nokia_inter."AdjiUARFCN" AS "UARFCN_v",
  topo2."GN" AS "GN_v", 
  round(cast(|/( (topo1."X"::int-topo2."X"::int) ^ 2 + (topo1."Y"::int-topo2."Y"::int) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_voisines3g3g_nokia_inter INNER JOIN public.t_vois_xfreql2100_00_topo AS topo1
  ON 
	t_voisines3g3g_nokia_inter."managedObject_WCEL" = topo1.localcellid
  INNER JOIN public.t_vois_xfreql2100_00_topo AS topo2
  ON
	t_voisines3g3g_nokia_inter."LCIDV" = topo2.localcellid
WHERE 
   "UARFCN_s" = '10787' AND
   "AdjiUARFCN" = '3011' AND
   t_voisines3g3g_nokia_inter."managedObject_WCEL" NOT IN ( --suppression des cellules qui existent en avance de phase sur OMC Nokia, toujours ALU
	SELECT localcellid
	FROM public.snap3g_fddcell)
;



--Ajout du ranking sur le plan fdd10 :
DROP TABLE IF EXISTS t_vois_xfreql2100_02_planfdd10_ranked;
CREATE TABLE t_vois_xfreql2100_02_planfdd10_ranked AS
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY "LCIDS","UARFCN_v"  ORDER BY distance_km ASC, name_v ASC) AS ranking
FROM 
  public.t_vois_xfreql2100_01_planfdd10
ORDER BY
  name_s,
  "UARFCN_v",
  ranking;

--Creation de la table de mapping FDD10-FDD7
-- ATTENTION EN FRONTIERE d'UR IL VA MANQUER LES VOISINES
DROP TABLE IF EXISTS t_voisnokia_mapping_fdd10_fdd7;
CREATE TABLE t_voisnokia_mapping_fdd10_fdd7 AS

SELECT 
  fddcell1.fddcell AS name_fdd10, 
  fddcell1.localcellid AS "LCID_fdd10", 
  fddcell1.dlfrequencynumber AS "UARFCN_fdd10", 
  fddcell2.fddcell AS name_fdd7, 
  fddcell2.localcellid AS "LCID_fdd7", 
  fddcell2.dlfrequencynumber AS "UARFCN_fdd7",
  t_vois_xfreql2100_00_topo."GN"
FROM 
  public.snap3g_fddcell fddcell1 INNER JOIN public.snap3g_fddcell fddcell2
  ON
	fddcell1.nodeb = fddcell2.nodeb
  LEFT JOIN t_vois_xfreql2100_00_topo
  ON
	fddcell1.localcellid = t_vois_xfreql2100_00_topo.localcellid
WHERE
  fddcell1.dlfrequencynumber = '10787' AND
  fddcell2.dlfrequencynumber = '10712' AND
  left(right(fddcell1.fddcell,2),1) = left(right(fddcell2.fddcell,2),1)

UNION

SELECT 
  "WCEL1".name, 
  "WCEL1"."managedObject_WCEL", 
  "WCEL1"."UARFCN", 
  "WCEL2".name, 
  "WCEL2"."managedObject_WCEL", 
  "WCEL2"."UARFCN",
  t_vois_xfreql2100_00_topo."GN"
FROM 
  public."nokia_WCEL" AS "WCEL1" INNER JOIN public."nokia_WCEL" AS "WCEL2"
  ON 
	"WCEL1"."managedObject_distName_parent" = "WCEL2"."managedObject_distName_parent"
  LEFT JOIN t_vois_xfreql2100_00_topo
  ON
	"WCEL1"."managedObject_WCEL" = t_vois_xfreql2100_00_topo.localcellid
WHERE
  "WCEL1"."UARFCN" = '10787' AND
  "WCEL2"."UARFCN" = '10712' AND
  left(right("WCEL1".name,2),1) = left(right("WCEL2".name,2),1) AND
  "WCEL1"."managedObject_WCEL" NOT IN ( --suppression des cellules qui existent en avance de phase sur OMC Nokia mais toujours ALU
	SELECT localcellid
	FROM public.snap3g_fddcell)
;


 