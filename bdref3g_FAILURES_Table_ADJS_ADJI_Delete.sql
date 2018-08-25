SELECT 
  bdref_visuincohtopo_vois_nokia.*
FROM 
  public.bdref_visuincohtopo_vois_nokia LEFT JOIN public.t_adjs_adji_generic_delete
  ON
  bdref_visuincohtopo_vois_nokia."LCIDs" = t_adjs_adji_generic_delete."LCIDs" AND
  bdref_visuincohtopo_vois_nokia."LCIDv" = t_adjs_adji_generic_delete."LCIDv" AND
  bdref_visuincohtopo_vois_nokia."Opération" = t_adjs_adji_generic_delete."Opération"
WHERE
  t_adjs_adji_generic_delete."LCIDs" IS NULL AND
  bdref_visuincohtopo_vois_nokia."Opération" ILIKE 'S%' AND 
  bdref_visuincohtopo_vois_nokia."Etats" IN ('OK','enintégration');