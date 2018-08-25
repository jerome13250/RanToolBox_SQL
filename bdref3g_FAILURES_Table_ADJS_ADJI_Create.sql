SELECT
  bdref_visuincohtopo_vois_nokia.*
FROM 
  public.bdref_visuincohtopo_vois_nokia LEFT JOIN public.t_adjs_adji_generic_create
  ON
  bdref_visuincohtopo_vois_nokia."LCIDs" = t_adjs_adji_generic_create."LCIDs" AND
  bdref_visuincohtopo_vois_nokia."LCIDv" = t_adjs_adji_generic_create."LCIDv"
WHERE
  t_adjs_adji_generic_create."LCIDs" IS NULL AND --voisinage non scripté
  bdref_visuincohtopo_vois_nokia."Opération" = 'Ajout' AND 
  bdref_visuincohtopo_vois_nokia."Etats" IN ('OK','enintégration') AND
  bdref_visuincohtopo_vois_nokia."NOMs" != '' AND --supprime les serveuses non remontées OMC
  bdref_visuincohtopo_vois_nokia."NOMv" != '' AND --supprime les voisines non remontées
  bdref_visuincohtopo_vois_nokia."NOMv" != 'EXTERNE' --supprime les voisines EXTERNE
;