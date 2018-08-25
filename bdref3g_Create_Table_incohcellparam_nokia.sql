DROP TABLE IF EXISTS t_wcel_generic_corrections;
CREATE TABLE t_wcel_generic_corrections AS

SELECT 
  CASE 	WHEN bdref_wcel_param_mapping.object_type='WCEL' THEN t_topologie3g_nokia."WCEL_managedObject_distName" || bdref_wcel_param_mapping.subobject_type
	WHEN bdref_wcel_param_mapping.object_type='LCELW' THEN t_topologie3g_nokia."LCELW_managedObject_distName"
        ELSE 'ERROR'::text END 
	AS object_distname,
  t_topologie3g_nokia.name, 
  bdref_wcel_param_mapping.param_name,
  bdref_incohparam_cell_nokia."Valeur" AS param_value,
  CASE 	WHEN bdref_wcel_param_mapping.subobject_type LIKE '%ADJL%' THEN 'ADJL'
        ELSE bdref_wcel_param_mapping.object_type END 
	AS real_object --sert a donner le vrai type d'objet, ADJL étant donné dans subobject_type

FROM 
  public.bdref_incohparam_cell_nokia INNER JOIN public.t_topologie3g_nokia
  ON
    bdref_incohparam_cell_nokia."LCID" = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN public.bdref_wcel_param_mapping
  ON
    bdref_incohparam_cell_nokia."Paramètre" = bdref_wcel_param_mapping.parametre;
