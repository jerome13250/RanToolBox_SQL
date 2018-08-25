--verification du parametre 'RtHopiIdentifier':
SELECT 
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

ORDER BY
  name_s,
  adji_name;