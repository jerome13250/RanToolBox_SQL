DROP TABLE IF EXISTS t_adj_generic_corrections;
CREATE TABLE t_adj_generic_corrections AS

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
  adji_name AS name_v,
  "LCIDV",
  "AdjiLAC",
  "AdjiRAC", 
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

ORDER BY
  name_s,
  name_v,
  parametre;
