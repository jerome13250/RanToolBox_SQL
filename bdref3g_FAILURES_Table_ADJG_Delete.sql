SELECT 
  bdref_visuincohtopo_vois_3g2g_nokia.*
FROM 
  public.bdref_visuincohtopo_vois_3g2g_nokia LEFT JOIN public.t_adjg_generic_delete
ON
  bdref_visuincohtopo_vois_3g2g_nokia."LCIDs" = t_adjg_generic_delete."LCIDs" AND
  bdref_visuincohtopo_vois_3g2g_nokia."LACv" = t_adjg_generic_delete."LACv" AND
  bdref_visuincohtopo_vois_3g2g_nokia."CIv" = t_adjg_generic_delete."CIv"
WHERE
  t_adjg_generic_delete."LCIDs" IS NULL AND --Pas de correspondance
  bdref_visuincohtopo_vois_3g2g_nokia."Opération" ILIKE 'S%' AND
  bdref_visuincohtopo_vois_3g2g_nokia."Etats" IN ('OK','enintégration');
