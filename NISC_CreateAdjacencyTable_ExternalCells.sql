SELECT 
  t_topologie2g."BSCName", 
  t_topologie2g."SiteName", 
  t_topologie2g."codeOMC", 
  t_topologie2g."SiteID", 
  t_topologie2g."CellName", 
  t_topologie2g.lac, 
  t_topologie2g.ci, 
  nisc_externalomccell."CellGlobalIdentity", 
  nisc_externalomccell."UserLabel"
FROM 
  public.t_topologie2g, 
  public.t_nisc_adjacency_updated, 
  public.nisc_externalomccell
WHERE 
  t_nisc_adjacency_updated.source_cell = t_topologie2g."CellInstanceIdentifier" AND
  t_nisc_adjacency_updated."RelatedTargetCell" = nisc_externalomccell."ExternalOmcCellInstanceIdentifier"
  AND t_topologie2g.lac IN ('20480','20484')
ORDER BY
  nisc_externalomccell."CellGlobalIdentity" ASC;
