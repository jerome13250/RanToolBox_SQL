SELECT
  bdref_visuincohtopo_vois_3g2g_nokia.*
FROM 
  public.bdref_visuincohtopo_vois_3g2g_nokia LEFT JOIN public.t_adjg_generic_create
  ON
  bdref_visuincohtopo_vois_3g2g_nokia."LCIDs" = t_adjg_generic_create."LCIDs" AND
  bdref_visuincohtopo_vois_3g2g_nokia."CIv" = t_adjg_generic_create."CIv" AND
  bdref_visuincohtopo_vois_3g2g_nokia."LACv" = t_adjg_generic_create."LACv"
WHERE
  t_adjg_generic_create."LCIDs" IS NULL AND --voisinage non scripté
  bdref_visuincohtopo_vois_3g2g_nokia."Opération" = 'Ajout' AND 
  bdref_visuincohtopo_vois_3g2g_nokia."Etats" IN ('OK','enintégration') AND
  bdref_visuincohtopo_vois_3g2g_nokia."NOMs" != '' AND --supprime les serveuses non remontées OMC
  bdref_visuincohtopo_vois_3g2g_nokia."NOMv" != '' AND --supprime les voisines non remontées
  bdref_visuincohtopo_vois_3g2g_nokia."NOMv" != 'EXTERNE' --supprime les voisines EXTERNE
;