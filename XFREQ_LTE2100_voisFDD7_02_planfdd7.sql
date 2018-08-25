--Création du plan thérique fdd7 3g3g cloning de celui de fdd10

DROP TABLE IF EXISTS t_vois_xfreql2100_03_planfdd7_umts;
CREATE TABLE t_vois_xfreql2100_03_planfdd7_umts AS

--plan de voisines fdd7-femto FDD7:
SELECT 
  t_voisnokia_mapping_fdd10_fdd7.name_fdd7 AS "name_s", 
  t_voisnokia_mapping_fdd10_fdd7."LCID_fdd7" AS "LCIDs", 
  t_voisnokia_mapping_fdd10_fdd7."UARFCN_fdd7" AS "UARFCN_s",
  t_voisnokia_mapping_fdd10_fdd7."GN" AS "GN_s", 
  t_list_supercell.name AS "name_v", 
  t_list_supercell."LCID"  AS "LCIDv",
  t_list_supercell."UARFCN" AS "UARFCN_v",
  'Femto'::text AS "GN_v",
  'Nan' AS distance_km, 
  0::int AS ranking,
  'A'::text AS operation
FROM 
  public.t_voisnokia_mapping_fdd10_fdd7, 
  public.t_list_supercell

UNION

--plan de voisines fdd7-fdd7 cloné depuis fdd10-fdd10:
SELECT 
  mapping1.name_fdd7 AS "name_s", 
  mapping1."LCID_fdd7" AS "LCIDs", 
  mapping1."UARFCN_fdd7" AS "UARFCN_s",
  mapping1."GN" AS "GN_s",
  mapping2.name_fdd7 AS "name_v", 
  mapping2."LCID_fdd7" AS "LCIDv",
  mapping2."UARFCN_fdd7" AS "UARFCN_v",
  mapping2."GN" AS "GN_v",
  t_planfdd10.distance_km, 
  t_planfdd10.ranking,
  'A'::text AS operation
FROM 
  public.t_vois_xfreql2100_02_planfdd10_ranked AS t_planfdd10, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping1, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping2
WHERE 
  t_planfdd10."LCIDS" = mapping1."LCID_fdd10" AND
  t_planfdd10."LCIDV" = mapping2."LCID_fdd10" 
  AND t_planfdd10.ranking < 25


UNION
--plan de voisines fdd7-fdd10 cosecteur:
SELECT 
  t_voisnokia_mapping_fdd10_fdd7.name_fdd7, 
  t_voisnokia_mapping_fdd10_fdd7."LCID_fdd7", 
  t_voisnokia_mapping_fdd10_fdd7."UARFCN_fdd7",
  t_voisnokia_mapping_fdd10_fdd7."GN" AS "GN_s",
  t_voisnokia_mapping_fdd10_fdd7.name_fdd10, 
  t_voisnokia_mapping_fdd10_fdd7."LCID_fdd10", 
  t_voisnokia_mapping_fdd10_fdd7."UARFCN_fdd10",
  t_voisnokia_mapping_fdd10_fdd7."GN" AS "GN_v",
  0::int AS distance_km, 
  0::int AS ranking,
  'A'::text AS operation
FROM 
  public.t_voisnokia_mapping_fdd10_fdd7


UNION
--plan de voisines fdd10-fdd7 cosecteur:
SELECT 
  t_voisnokia_mapping_fdd10_fdd7.name_fdd10, 
  t_voisnokia_mapping_fdd10_fdd7."LCID_fdd10", 
  t_voisnokia_mapping_fdd10_fdd7."UARFCN_fdd10",
  t_voisnokia_mapping_fdd10_fdd7."GN" AS "GN_s",
  t_voisnokia_mapping_fdd10_fdd7.name_fdd7, 
  t_voisnokia_mapping_fdd10_fdd7."LCID_fdd7", 
  t_voisnokia_mapping_fdd10_fdd7."UARFCN_fdd7",
  t_voisnokia_mapping_fdd10_fdd7."GN" AS "GN_v",
  0::int AS distance_km, 
  0::int AS ranking,
  'A'::text AS operation
FROM 
  public.t_voisnokia_mapping_fdd10_fdd7

UNION 
--plan de voisines fdd7-fdd10 cloné depuis fdd10-fdd10:

SELECT 
  mapping1.name_fdd7 AS "name_s", 
  mapping1."LCID_fdd7" AS "LCIDs", 
  mapping1."UARFCN_fdd7" AS "UARFCN_s",
  mapping1."GN" AS "GN_s", 
  t_planfdd10.name_v AS "name_v", 
  t_planfdd10."LCIDV",
  t_planfdd10."UARFCN_v",
  t_planfdd10."GN_v",
  t_planfdd10.distance_km, 
  t_planfdd10.ranking,
  'A'::text AS operation
FROM 
  public.t_vois_xfreql2100_02_planfdd10_ranked AS t_planfdd10, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping1
WHERE 
  t_planfdd10."LCIDS" = mapping1."LCID_fdd10" AND
  "UARFCN_v" = '10787' AND
  t_planfdd10.ranking < 12 
  --AND name_s LIKE 'YTRAC_SABLIERE_%'

UNION 
--plan de voisines fdd7-fdd900 cloné depuis fdd10-fdd900:

SELECT 
  mapping1.name_fdd7 AS "name_s", 
  mapping1."LCID_fdd7" AS "LCIDs", 
  mapping1."UARFCN_fdd7" AS "UARFCN_s",
  mapping1."GN" AS "GN_s",  
  t_planfdd10.name_v AS "name_v", 
  t_planfdd10."LCIDV",
  t_planfdd10."UARFCN_v",
  t_planfdd10."GN_v",
  t_planfdd10.distance_km, 
  t_planfdd10.ranking,
  'A'::text AS operation
FROM 
  public.t_vois_xfreql2100_02_planfdd10_ranked AS t_planfdd10, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping1
WHERE 
  t_planfdd10."LCIDS" = mapping1."LCID_fdd10" AND
  "UARFCN_v" = '3011' AND
  t_planfdd10.ranking <= 15 

ORDER BY 
  "name_s",
  "UARFCN_v",
  ranking;