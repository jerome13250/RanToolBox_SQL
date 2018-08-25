--creation de la liste des X-Y sur toutes les cellules des 2 OMCs:
DROP TABLE IF EXISTS t_vois_xfreql2100_00_topo;
CREATE TABLE t_vois_xfreql2100_00_topo AS

SELECT 
  snap3g_fddcell.nodeb, 
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.localcellid,
  t_noria_topo_3g."GN", 
  t_noria_topo_3g."X", 
  t_noria_topo_3g."Y"
FROM 
  public.snap3g_fddcell LEFT JOIN public.t_noria_topo_3g
  ON
  snap3g_fddcell.localcellid = t_noria_topo_3g."IDRESEAUCELLULE"

UNION

SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL".name, 
  "nokia_WCEL"."managedObject_WCEL",
  t_noria_topo_3g."GN",
  t_noria_topo_3g."X", 
  t_noria_topo_3g."Y"
FROM 
  public."nokia_WCEL"LEFT JOIN public.t_noria_topo_3g
  ON
  "nokia_WCEL"."managedObject_WCEL" = t_noria_topo_3g."IDRESEAUCELLULE"
WHERE
   "managedObject_WCEL" NOT IN ( --suppression des cellules qui existent en avance de phase sur OMC Nokia, toujours ALU
	SELECT localcellid
	FROM public.snap3g_fddcell);
	

--Creation du mapping nodeb - coord
DROP TABLE IF EXISTS t_vois_xfreql2100_00_nodeb_coord;
CREATE TABLE t_vois_xfreql2100_00_nodeb_coord AS

SELECT DISTINCT
  nodeb,
  min("GN") AS "GN",  
  min("X") AS "X", 
  min("Y") AS "Y"
FROM 
  public.t_vois_xfreql2100_00_topo
WHERE 
  "X" IS NOT NULL
GROUP BY 
  nodeb;

--Mise a jour des coordonnées et GN nulles sur les lcid dont le nodeb est déja connu:
UPDATE public.t_vois_xfreql2100_00_topo AS topo_omc
SET 
  "GN" = nodeb_coord."GN",
  "X" = nodeb_coord."X",
  "Y" = nodeb_coord."Y"
FROM 
  public.t_vois_xfreql2100_00_nodeb_coord AS nodeb_coord
WHERE 
  topo_omc.nodeb = nodeb_coord.nodeb AND
  topo_omc."X" IS NULL;

--Ajout de la topologie Noria hors de notre OMC:
INSERT INTO t_vois_xfreql2100_00_topo
SELECT 
  NULL::text AS "nodeb", 
  t_noria_topo_3g."NOM", 
  t_noria_topo_3g."IDRESEAUCELLULE", 
  t_noria_topo_3g."GN",
  t_noria_topo_3g."X", 
  t_noria_topo_3g."Y"
FROM  
  public.t_noria_topo_3g LEFT JOIN public.t_vois_xfreql2100_00_topo
  ON
  t_noria_topo_3g."IDRESEAUCELLULE" = t_vois_xfreql2100_00_topo.localcellid
WHERE 
  t_vois_xfreql2100_00_topo.localcellid IS NULL;


