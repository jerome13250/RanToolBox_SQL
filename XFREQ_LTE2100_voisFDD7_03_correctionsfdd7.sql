DROP TABLE IF EXISTS t_vois_xfreql2100_03a_planfdd7_nk;
CREATE TABLE t_vois_xfreql2100_03a_planfdd7_nk AS
SELECT 
  name_s, 
  "LCIDs", 
  "UARFCN_s", 
  name_v, 
  "LCIDv", 
  "UARFCN_v", 
  distance_km, 
  ranking 
  
FROM 
  public.t_vois_xfreql2100_03_planfdd7_umts INNER JOIN public."nokia_WCEL"
  ON
	t_vois_xfreql2100_03_planfdd7_umts."LCIDs" = "managedObject_WCEL" --On ne prend que les cellules serveuses sur Nokia
WHERE
   "LCIDs" NOT IN ( --suppression des cellules qui existent en avance de phase sur OMC Nokia, toujours ALU
	SELECT localcellid
	FROM public.snap3g_fddcell)
;


--Liste des voisines FDD7-FDD7 manquantes sur nokia:
SELECT 
  t_vois_xfreql2100_03a_planfdd7_nk.name_s, 
  "LCIDs", 
  t_vois_xfreql2100_03a_planfdd7_nk."UARFCN_s", 
  name_v, 
  "LCIDv", 
  "UARFCN_v", 
  distance_km, 
  ranking 
FROM 
  public.t_vois_xfreql2100_03a_planfdd7_nk LEFT JOIN public.t_voisines3g3g_nokia_intra
  ON
	t_vois_xfreql2100_03a_planfdd7_nk."LCIDs" = t_voisines3g3g_nokia_intra."LCIDS" AND
	t_vois_xfreql2100_03a_planfdd7_nk."LCIDv" = t_voisines3g3g_nokia_intra."LCIDV"
WHERE
  t_vois_xfreql2100_03a_planfdd7_nk."UARFCN_s" = '10712' AND
  t_vois_xfreql2100_03a_planfdd7_nk."UARFCN_v" = '10712' AND
  t_voisines3g3g_nokia_intra."LCIDS" IS NULL

UNION

--Liste des voisines FDD7-FDD900 manquantes sur nokia:
SELECT 
  t_vois_xfreql2100_03a_planfdd7_nk.name_s, 
  "LCIDs", 
  t_vois_xfreql2100_03a_planfdd7_nk."UARFCN_s", 
  name_v, 
  "LCIDv", 
  "UARFCN_v", 
  distance_km, 
  ranking 
FROM 
  public.t_vois_xfreql2100_03a_planfdd7_nk LEFT JOIN public.t_voisines3g3g_nokia_inter
  ON
	t_vois_xfreql2100_03a_planfdd7_nk."LCIDs" = t_voisines3g3g_nokia_inter."managedObject_WCEL" AND
	t_vois_xfreql2100_03a_planfdd7_nk."LCIDv" = t_voisines3g3g_nokia_inter."LCIDV"
WHERE
  t_vois_xfreql2100_03a_planfdd7_nk."UARFCN_s" = '10712' AND
  t_vois_xfreql2100_03a_planfdd7_nk."UARFCN_v" = '3011' AND
  t_voisines3g3g_nokia_inter."managedObject_WCEL" IS NULL
ORDER BY
  name_s,
  "UARFCN_v",
  ranking, 
  name_v;
