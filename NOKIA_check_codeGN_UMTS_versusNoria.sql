--Liste des erreurs détectées de code GN dans BTSAdditionalInfo et sbtsDescription:
--DROP TABLE IF EXISTS t_nokia_3g_codegn_errors;
--CREATE TABLE t_nokia_3g_codegn_errors AS

SELECT 
  t_topologie3g_nokia."RNC_managedObject_distName", 
  t_topologie3g_nokia."RNCName", 
  t_topologie3g_nokia."RNC_id", 
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo",
  t_topologie3g_nokia."SBTS_managedObject_distName",
  t_topologie3g_nokia."sbtsDescription",
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_noria_topo_3g."NOM", 
  t_noria_topo_3g."IDRESEAUCELLULE", 
  t_noria_topo_3g."GN" AS "NORIA_GN",
  'erreur de WBTS.BTSAdditionalInfo'::text AS commentaire
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_noria_topo_3g
  ON
	t_topologie3g_nokia."managedObject_WCEL" = t_noria_topo_3g."IDRESEAUCELLULE"  --Cle = LCID
WHERE
  t_topologie3g_nokia."WBTSName" IS NOT NULL  AND --La cellule a un SBTS Nokia associé donc n'est pas un EXUCE
  ( left(t_topologie3g_nokia."BTSAdditionalInfo",10) != t_noria_topo_3g."GN"  --On n'a pas le bon code GN à l'OMC // à Noria; restriction a 10 lettres cause _1 et _2 sur les coloc
    OR t_topologie3g_nokia."BTSAdditionalInfo" IS NULL 
    OR t_topologie3g_nokia."BTSAdditionalInfo" = ''
  )

UNION

SELECT 
  t_topologie3g_nokia."RNC_managedObject_distName", 
  t_topologie3g_nokia."RNCName", 
  t_topologie3g_nokia."RNC_id", 
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo",
  t_topologie3g_nokia."SBTS_managedObject_distName",
  t_topologie3g_nokia."sbtsDescription",
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_noria_topo_3g."NOM", 
  t_noria_topo_3g."IDRESEAUCELLULE", 
  t_noria_topo_3g."GN" AS "NORIA_GN",
  'erreur de SBTS.sbtsDescription'::text
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_noria_topo_3g
  ON
	t_topologie3g_nokia."managedObject_WCEL" = t_noria_topo_3g."IDRESEAUCELLULE"  --Cle = LCID
WHERE
  t_topologie3g_nokia."btsProfile" IS NOT NULL  AND --La cellule a un SBTS Nokia associé donc n'est pas un EXUCE
  ( left(t_topologie3g_nokia."sbtsDescription",10) != t_noria_topo_3g."GN"  --On n'a pas le bon code GN à l'OMC // à Noria; restriction a 10 lettres cause _1 et _2 sur les coloc
    OR t_topologie3g_nokia."sbtsDescription" IS NULL 
    OR t_topologie3g_nokia."sbtsDescription" = ''
  )

ORDER BY
  name;