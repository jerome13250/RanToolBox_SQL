SELECT 
  topo1."CellName", 
  topo1.lac, 
  topo1.ci, 
  topo1."AdministrativeState", 
  topo1."OperationalState", 
  topo1."AvailabilityStatus", 
  topo2."CellName", 
  topo2.lac, 
  topo2.ci, 
  topo2."AdministrativeState", 
  topo2."OperationalState", 
  topo2."AvailabilityStatus"
FROM 
  public.t_nisc_adjacency_updated INNER JOIN public.t_topologie2g topo1
	ON  t_nisc_adjacency_updated.source_cell = topo1."CellInstanceIdentifier"
  INNER JOIN public.t_topologie2g topo2
	ON t_nisc_adjacency_updated."RelatedTargetCell" = topo2."CellInstanceIdentifier"
WHERE 
  (topo1.lac IN ('20480','20484') AND topo2.lac NOT IN ('20480','20484'))
  OR 
  (topo1.lac NOT IN ('20480','20484') AND topo2.lac IN ('20480','20484'))
  ;
