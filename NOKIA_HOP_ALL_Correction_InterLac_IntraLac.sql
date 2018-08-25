DROP TABLE IF EXISTS t_adj_generic_corrections;
CREATE TABLE t_adj_generic_corrections AS

/*Vérification interLac sur les 2 params HOPI:
  "nokia_ADJI"."RtHopiIdentifier",
  "nokia_ADJI"."NrtHopiIdentifier" */

--verification du parametre 'RtHopiIdentifier':
SELECT 
  "ADJI_managedObject_distName" AS "managedObject_distName",
  'ADJI'::text AS class,
  name_s,
  "managedObject_WCEL" AS "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC" AS "LAC_s",
  "RAC" AS "RAC_s",
  "UARFCN_s",
  adji_name AS name_v,
  "LCIDV",
  "AdjiLAC" AS "LAC_v",
  "AdjiRAC" AS "RAC_v", 
  'RtHopiIdentifier'::text AS parametre,
  "RtHopiIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hopi_interlac.name_intralac,
  bdref_mapping_nokia_hopi_interlac.hopi_interlac AS valeur, 
  bdref_mapping_nokia_hopi_interlac.name_interlac,
  'CORRECTION INTERLAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hopi_interlac INNER JOIN public.t_voisines3g3g_nokia_inter
  ON 
	t_voisines3g3g_nokia_inter."RtHopiIdentifier" = bdref_mapping_nokia_hopi_interlac.hopi_intralac
WHERE 
  t_voisines3g3g_nokia_inter."LAC" != t_voisines3g3g_nokia_inter."AdjiLAC" OR
  t_voisines3g3g_nokia_inter."RAC" != t_voisines3g3g_nokia_inter."AdjiRAC"

UNION 

--verification du parametre 'NrtHopiIdentifier':
SELECT 
  "ADJI_managedObject_distName",
  'ADJI'::text AS class,
  name_s,
  "managedObject_WCEL" AS "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adji_name,
  "LCIDV",
  "AdjiLAC",
  "AdjiRAC", 
  'NrtHopiIdentifier'::text AS parametre,
  "NrtHopiIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hopi_interlac.name_intralac,
  bdref_mapping_nokia_hopi_interlac.hopi_interlac AS valeur, 
  bdref_mapping_nokia_hopi_interlac.name_interlac,
  'CORRECTION INTERLAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hopi_interlac INNER JOIN public.t_voisines3g3g_nokia_inter
  ON 
	t_voisines3g3g_nokia_inter."NrtHopiIdentifier" = bdref_mapping_nokia_hopi_interlac.hopi_intralac
WHERE 
  t_voisines3g3g_nokia_inter."LAC" != t_voisines3g3g_nokia_inter."AdjiLAC" OR
  t_voisines3g3g_nokia_inter."RAC" != t_voisines3g3g_nokia_inter."AdjiRAC"

UNION

/*Vérification interLac sur les 4 params HOPS:
  "nokia_ADJS"."RtHopsIdentifier",
  "nokia_ADJS"."RTWithHSDPAHopsIdentifier",
  "nokia_ADJS"."NrtHopsIdentifier",
  "nokia_ADJS"."HSDPAHopsIdentifier"
 */

--verification du parametre 'RtHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'RtHopsIdentifier'::text AS parametre,
  "RtHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."RtHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"

UNION

--verification du parametre 'RTWithHSDPAHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'RTWithHSDPAHopsIdentifier'::text AS parametre,
  "RTWithHSDPAHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."RTWithHSDPAHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"

UNION

--verification du parametre 'NrtHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'NrtHopsIdentifier'::text AS parametre,
  "NrtHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."NrtHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"
  
UNION

--verification du parametre 'HSDPAHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'HSDPAHopsIdentifier'::text AS parametre,
  "HSDPAHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."HSDPAHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"  
  

UNION

/*Vérification interLac sur les 2 params HOPI:
  "nokia_ADJI"."RtHopiIdentifier",
  "nokia_ADJI"."NrtHopiIdentifier" */

--verification du parametre 'RtHopiIdentifier':
SELECT 
  "ADJI_managedObject_distName" AS "managedObject_distName",
  'ADJI'::text AS class,
  name_s,
  "managedObject_WCEL" AS "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adji_name,
  "LCIDV",
  "AdjiLAC",
  "AdjiRAC", 
  'RtHopiIdentifier'::text AS parametre,
  "RtHopiIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hopi_interlac.name_interlac,
  bdref_mapping_nokia_hopi_interlac.hopi_intralac AS valeur, 
  bdref_mapping_nokia_hopi_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hopi_interlac INNER JOIN public.t_voisines3g3g_nokia_inter
  ON 
	t_voisines3g3g_nokia_inter."RtHopiIdentifier" = bdref_mapping_nokia_hopi_interlac.hopi_interlac
WHERE 
  t_voisines3g3g_nokia_inter."LAC" = t_voisines3g3g_nokia_inter."AdjiLAC" AND
  t_voisines3g3g_nokia_inter."RAC" = t_voisines3g3g_nokia_inter."AdjiRAC"

UNION 

--verification du parametre 'NrtHopiIdentifier':
SELECT 
  "ADJI_managedObject_distName" AS "managedObject_distName",
  'ADJI'::text AS class,
  name_s,
  "managedObject_WCEL" AS "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adji_name,
  "LCIDV",
  "AdjiLAC",
  "AdjiRAC", 
  'NrtHopiIdentifier'::text AS parametre,
  "NrtHopiIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hopi_interlac.name_interlac,
  bdref_mapping_nokia_hopi_interlac.hopi_intralac AS valeur, 
  bdref_mapping_nokia_hopi_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hopi_interlac INNER JOIN public.t_voisines3g3g_nokia_inter
  ON 
	t_voisines3g3g_nokia_inter."NrtHopiIdentifier" = bdref_mapping_nokia_hopi_interlac.hopi_interlac
WHERE 
  t_voisines3g3g_nokia_inter."LAC" = t_voisines3g3g_nokia_inter."AdjiLAC" AND
  t_voisines3g3g_nokia_inter."RAC" = t_voisines3g3g_nokia_inter."AdjiRAC"

  
UNION

/*Vérification intraLac sur les 4 params HOPS:
  "nokia_ADJS"."RtHopsIdentifier",
  "nokia_ADJS"."RTWithHSDPAHopsIdentifier",
  "nokia_ADJS"."NrtHopsIdentifier",
  "nokia_ADJS"."HSDPAHopsIdentifier"
 */

--verification du parametre 'RtHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'RtHopsIdentifier'::text AS parametre,
  "RtHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."RtHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"

UNION

--verification du parametre 'RTWithHSDPAHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'RTWithHSDPAHopsIdentifier'::text AS parametre,
  "RTWithHSDPAHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."RTWithHSDPAHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"

UNION

--verification du parametre 'NrtHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'NrtHopsIdentifier'::text AS parametre,
  "NrtHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."NrtHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"
  
UNION

--verification du parametre 'HSDPAHopsIdentifier':
SELECT 
  "ADJS_managedObject_distName" AS "managedObject_distName",
  'ADJS'::text AS class,
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'HSDPAHopsIdentifier'::text AS parametre,
  "HSDPAHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_interlac,
  bdref_mapping_nokia_hops_interlac.hops_intralac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_intralac,
  'CORRECTION INTRALAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."HSDPAHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_interlac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" = t_voisines3g3g_nokia_intra."AdjsLAC" AND
  t_voisines3g3g_nokia_intra."RAC" = t_voisines3g3g_nokia_intra."AdjsRAC"  
    
  
  
ORDER BY
  name_s,
  name_v,
  parametre
 ;





