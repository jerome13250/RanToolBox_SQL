/*Vérification interLac sur les 4 params HOPS:
  "nokia_ADJS"."RtHopsIdentifier",
  "nokia_ADJS"."RTWithHSDPAHopsIdentifier",
  "nokia_ADJS"."NrtHopsIdentifier",
  "nokia_ADJS"."HSDPAHopsIdentifier"
 */

--verification du parametre 'RtHopsIdentifier':
SELECT 
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name AS name_v,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'RtHopsIdentifier'::text AS parametre,
  "RtHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_intralac,
  bdref_mapping_nokia_hops_interlac.hops_interlac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_interlac,
  'CORRECTION INTERLAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."RtHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_intralac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" != t_voisines3g3g_nokia_intra."AdjsLAC" OR
  t_voisines3g3g_nokia_intra."RAC" != t_voisines3g3g_nokia_intra."AdjsRAC"

UNION 

--verification du parametre 'RTWithHSDPAHopsIdentifier':
SELECT 
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name  AS name_v,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'RTWithHSDPAHopsIdentifier'::text AS parametre,
  "RTWithHSDPAHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_intralac,
  bdref_mapping_nokia_hops_interlac.hops_interlac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_interlac,
  'CORRECTION INTERLAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."RTWithHSDPAHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_intralac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" != t_voisines3g3g_nokia_intra."AdjsLAC" OR
  t_voisines3g3g_nokia_intra."RAC" != t_voisines3g3g_nokia_intra."AdjsRAC"

UNION

--verification du parametre 'NrtHopiIdentifier':
SELECT 
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name  AS name_v,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'NrtHopsIdentifier'::text AS parametre,
  "NrtHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_intralac,
  bdref_mapping_nokia_hops_interlac.hops_interlac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_interlac,
  'CORRECTION INTERLAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."NrtHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_intralac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" != t_voisines3g3g_nokia_intra."AdjsLAC" OR
  t_voisines3g3g_nokia_intra."RAC" != t_voisines3g3g_nokia_intra."AdjsRAC"

UNION

--verification du parametre 'HSDPAHopsIdentifier':
SELECT 
  name_s,
  "LCIDS",
  rnc_id_s,
  cid_s,
  "LAC",
  "RAC",
  "UARFCN_s",
  adjs_name  AS name_v,
  "LCIDV",
  "AdjsLAC",
  "AdjsRAC", 
  'HSDPAHopsIdentifier'::text AS parametre,
  "HSDPAHopsIdentifier" AS valeurOMC,
  bdref_mapping_nokia_hops_interlac.name_intralac,
  bdref_mapping_nokia_hops_interlac.hops_interlac AS valeur, 
  bdref_mapping_nokia_hops_interlac.name_interlac,
  'CORRECTION INTERLAC' AS commentaire
FROM 
  public.bdref_mapping_nokia_hops_interlac INNER JOIN public.t_voisines3g3g_nokia_intra
  ON 
	t_voisines3g3g_nokia_intra."HSDPAHopsIdentifier" = bdref_mapping_nokia_hops_interlac.hops_intralac
WHERE 
  t_voisines3g3g_nokia_intra."LAC" != t_voisines3g3g_nokia_intra."AdjsLAC" OR
  t_voisines3g3g_nokia_intra."RAC" != t_voisines3g3g_nokia_intra."AdjsRAC"

ORDER BY
  name_s,
  adjs_name,
  parametre
 ;
