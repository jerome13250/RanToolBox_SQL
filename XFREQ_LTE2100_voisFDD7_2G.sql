--creation de la liste des distances 3G vers 2G à l'OMC:
DROP TABLE IF EXISTS t_vois_xfreql2100_2G_omc;
CREATE TABLE t_vois_xfreql2100_2G_omc AS
SELECT DISTINCT
  t_voisines3g2g_nokia.name_s, 
  t_voisines3g2g_nokia."LCIDs", 
  topo3g."GN", 
  t_voisines3g2g_nokia."managedObject_version", 
  t_voisines3g2g_nokia."managedObject_id", 
  t_voisines3g2g_nokia."managedObject_distName", 
  t_voisines3g2g_nokia."AdjgLAC", 
  t_voisines3g2g_nokia."AdjgCI",
  noria_cellulesgsm."NOM" AS name_v,
  round(cast(|/( (topo3g."X"::int-noria_site."X"::int) ^ 2 + (topo3g."Y"::int-noria_site."Y"::int) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
  public.t_voisines3g2g_nokia INNER JOIN public.t_vois_xfreql2100_00_topo AS topo3g
  ON 
	t_voisines3g2g_nokia."LCIDs" = topo3g.localcellid
  LEFT JOIN public.noria_cellulesgsm
  ON
	t_voisines3g2g_nokia."AdjgCI" = noria_cellulesgsm."IDRESEAUCELLULE" AND
	t_voisines3g2g_nokia."AdjgLAC" = noria_cellulesgsm."TAC/LAC"
  INNER JOIN public.noria_candidat
  ON
	noria_cellulesgsm."GN" = noria_candidat."GN" AND
	noria_cellulesgsm."CANDIDAT" = noria_candidat."CANDIDAT"
  INNER JOIN public.noria_site
  ON
	noria_candidat."CODESITE" = noria_site."CODE_SITE"
WHERE
  "CONSTRUCTEUR" NOT IN ('SELECOM','POWERWAVE','ANDREW','MIKOM','COMMSCOPE','SAGEM')
ORDER BY
  round(cast(|/( (topo3g."X"::int-noria_site."X"::int) ^ 2 + (topo3g."Y"::int-noria_site."Y"::int) ^ 2) as numeric)/1000,2) DESC
;

--ranking des 3G 2G:
DROP TABLE IF EXISTS t_vois_xfreql2100_2G_omc_ranked;
CREATE TABLE t_vois_xfreql2100_2G_omc_ranked AS
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY "LCIDs"  ORDER BY distance_km ASC, name_v ASC) AS ranking
FROM 
  public.t_vois_xfreql2100_2G_omc
ORDER BY
  name_s,
  ranking;

--creation table vois FDD7 vers 2G:
DROP TABLE IF EXISTS t_vois_xfreql2100_2G_FDD7;
CREATE TABLE t_vois_xfreql2100_2G_FDD7 AS
SELECT 
  t_voisnokia_mapping_fdd10_fdd7.name_fdd7 AS name_s, 
  t_voisnokia_mapping_fdd10_fdd7."LCID_fdd7" AS "LCIDS", 
  t_vois_xfreql2100_2g_omc_ranked."GN", 
  t_vois_xfreql2100_2g_omc_ranked.name_v, 
  t_vois_xfreql2100_2g_omc_ranked."AdjgLAC" AS "LACv", 
  t_vois_xfreql2100_2g_omc_ranked."AdjgCI" AS "CIv", 
  t_vois_xfreql2100_2g_omc_ranked.distance_km, 
  t_vois_xfreql2100_2g_omc_ranked.ranking,
  'A'::text AS "Operation",
  'AdjgSIB'::text AS "parametre",
  CASE 
	WHEN ranking <= 12 THEN '1'::text
	ELSE '0'::text
  END AS "valeur"
FROM 
  public.t_vois_xfreql2100_2g_omc_ranked INNER JOIN public.t_voisnokia_mapping_fdd10_fdd7
  ON
  t_vois_xfreql2100_2g_omc_ranked."LCIDs" = t_voisnokia_mapping_fdd10_fdd7."LCID_fdd10";

