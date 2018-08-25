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
  adjs_name,
  parametre
 ;
