SELECT 
  t_topologie3g_nokia."RNC_managedObject_distName", 
  t_topologie3g_nokia."RNCName", 
  t_topologie3g_nokia."RNC_id", 
  t_topologie3g_nokia."WBTSName", 
  t_topologie3g_nokia."WBTS_managedObject_distName", 
  t_topologie3g_nokia."BTSAdditionalInfo", 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_noria_topo_3g."NOM", 
  t_noria_topo_3g."IDRESEAUCELLULE", 
  t_noria_topo_3g."GN" AS "NORIA_GN"
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_noria_topo_3g
  ON
	t_topologie3g_nokia."managedObject_WCEL" = t_noria_topo_3g."IDRESEAUCELLULE"  --Cle = LCID
WHERE
  t_topologie3g_nokia."WBTSName" IS NOT NULL  AND --La cellule a un SBTS Nokia associé donc n'est pas un EXUCE
  ( t_topologie3g_nokia."BTSAdditionalInfo" != t_noria_topo_3g."GN"  --On n'a pas le bon code GN à l'OMC // à Noria
    OR t_topologie3g_nokia."BTSAdditionalInfo" IS NULL 
  )
;
