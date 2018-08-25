SELECT 
  t_topologie3g_nokia.name, 
  t_topologie3g_nokia."managedObject_WCEL", 
  t_topologie3g_nokia."WCEL_managedObject_distName", 
  t_topologie3g_nokia.netact_tpl, 
  t_topologie3g_nokia."UARFCN", 
  t_netact_template_information.defaults_name, 
  t_netact_template_information.nbfreq2100, 
  t_netact_template_information.frequence
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_netact_template_information
ON
  t_topologie3g_nokia.netact_tpl = t_netact_template_information.defaults_name
WHERE 
  t_topologie3g_nokia."managedObject_WCEL" NOT LIKE 'PLMN-PLMN/EXCCU-1/EXUCE-%' AND
  (t_topologie3g_nokia."UARFCN" != t_netact_template_information.frequence OR
  t_topologie3g_nokia.netact_tpl IS NULL)
ORDER BY 
  name;
