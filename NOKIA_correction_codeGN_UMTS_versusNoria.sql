DROP TABLE IF EXISTS t_allObjects_generic_corrections;
CREATE TABLE t_allObjects_generic_corrections AS 

SELECT DISTINCT
  t_topologie3g_nokia."WBTSName" AS name,
  'WBTS'::text AS object_class,
  t_topologie3g_nokia."WBTS_managedObject_distName" AS "managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo" AS old_value,
  'BTSAdditionalInfo'::text AS param_name,
  t_noria_topo_3g."GN" AS param_value,
  'correction de WBTS.BTSAdditionalInfo'::text AS commentaire
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_noria_topo_3g
  ON
	t_topologie3g_nokia."managedObject_WCEL" = t_noria_topo_3g."IDRESEAUCELLULE"  --Cle = LCID
WHERE
  t_topologie3g_nokia."WBTSName" IS NOT NULL  AND --La cellule a un SBTS Nokia associé donc n'est pas un EXUCE
  t_topologie3g_nokia."WBTSName" != 'SBTS-TEST' AND --exclusion des sbts test
  ( left(t_topologie3g_nokia."BTSAdditionalInfo",10) != t_noria_topo_3g."GN"  --On n'a pas le bon code GN à l'OMC // à Noria; restriction a 10 lettres cause _1 et _2 sur les coloc
    OR t_topologie3g_nokia."BTSAdditionalInfo" IS NULL 
    OR t_topologie3g_nokia."BTSAdditionalInfo" = ''
  )

UNION

SELECT DISTINCT
  t_topologie3g_nokia."WBTSName" AS name, 
  CASE 
	WHEN "SBTS_managedObject_distName" LIKE '%SBTS%' THEN 'SBTS'::text
	WHEN "SBTS_managedObject_distName" LIKE '%MRBTS%' THEN 'MRBTSDESC'::text
	ELSE 'ERROR'::text
  END AS object_class,
  CASE 
	WHEN "SBTS_managedObject_distName" LIKE '%SBTS%' THEN "SBTS_managedObject_distName"
	WHEN "SBTS_managedObject_distName" LIKE '%MRBTS%' THEN "SBTS_managedObject_distName" || '/MRBTSDESC-0'
	ELSE 'ERROR'::text
  END AS "managedObject_distName",
  t_topologie3g_nokia."sbtsDescription" AS old_value,
  CASE 
	WHEN "SBTS_managedObject_distName" LIKE '%SBTS%' THEN 'sbtsDescription'::text
	WHEN "SBTS_managedObject_distName" LIKE '%MRBTS%' THEN 'descriptiveName'::text 
	ELSE 'ERROR'::text
  END AS param_name,
  t_noria_topo_3g."GN" AS param_value,
    CASE 
	WHEN "SBTS_managedObject_distName" LIKE '%SBTS%' THEN 'erreur de SBTS.sbtsDescription'::text
	WHEN "SBTS_managedObject_distName" LIKE '%MRBTS%' THEN 'erreur de MRBTS.descriptiveName'::text 
	ELSE 'ERROR'::text
  END AS commentaire
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_noria_topo_3g
  ON
	t_topologie3g_nokia."managedObject_WCEL" = t_noria_topo_3g."IDRESEAUCELLULE"  --Cle = LCID
WHERE
  t_topologie3g_nokia."btsProfile" IS NOT NULL  AND --La cellule a un SBTS Nokia associé donc n'est pas un EXUCE
  t_topologie3g_nokia."WBTSName" != 'SBTS-TEST' AND --exclusion des sbts test
  ( left(t_topologie3g_nokia."sbtsDescription",10) != t_noria_topo_3g."GN"  --On n'a pas le bon code GN à l'OMC // à Noria; restriction a 10 lettres cause _1 et _2 sur les coloc
    OR t_topologie3g_nokia."sbtsDescription" IS NULL 
    OR t_topologie3g_nokia."sbtsDescription" = ''
  )

ORDER BY
  name;