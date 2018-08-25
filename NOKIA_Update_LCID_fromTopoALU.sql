--creation table temporaire des lcid a remplir:
DROP TABLE IF EXISTS tmp_topologie3gnokia_lcid_update;
CREATE TABLE tmp_topologie3gnokia_lcid_update AS

SELECT 
  t_topologie3g_nokia."WCEL_managedObject_distName",
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_topologie3g.fddcell, 
  t_topologie3g.localcellid
FROM 
  public.t_topologie3g_nokia INNER JOIN public.t_topologie3g
  ON 
	t_topologie3g_nokia."RNC_id" = t_topologie3g.rncid AND
	t_topologie3g_nokia."WCELMCC" = t_topologie3g.mobilecountrycode AND
	t_topologie3g_nokia."WCELMNC" = t_topologie3g.mobilenetworkcode AND
	t_topologie3g_nokia."CId" = t_topologie3g.cellid
WHERE 
  t_topologie3g_nokia."managedObject_WCEL" IS NULL; --Le LCID est inconnu dans le systeme Nokia

--mse a jour des lcid dans la topo:
UPDATE t_topologie3g_nokia AS t
 SET 
  "managedObject_WCEL" = tmp_topologie3gnokia_lcid_update.localcellid
  
 FROM 
  public.tmp_topologie3gnokia_lcid_update
WHERE 
  t."WCEL_managedObject_distName" = tmp_topologie3gnokia_lcid_update."WCEL_managedObject_distName";