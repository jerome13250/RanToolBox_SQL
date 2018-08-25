SELECT 
  topo1."BSCName", 
  topo1."SiteName", 
  topo1."codeOMC", 
  topo1."SiteID", 
  topo1."CellName", 
  topo1.lac, 
  topo1.ci, 
  topo2."BSCName", 
  topo2."SiteName", 
  topo2."codeOMC", 
  topo2."SiteID", 
  topo2."CellName" AS cellnamev, 
  topo2.lac AS lacv, 
  topo2.ci AS civ 
FROM 
  public.t_topologie2g AS topo1,
  public.t_topologie2g AS topo2,
  public.t_nisc_adjacency_updated
WHERE 
  t_nisc_adjacency_updated.source_cell = topo1."CellInstanceIdentifier" AND
  t_nisc_adjacency_updated."RelatedTargetCell" = topo2."CellInstanceIdentifier"
  AND topo1.lac IN ('20480','20484')
  AND topo2.lac NOT IN ('20480','20484')
ORDER BY
  topo1."CellInstanceIdentifier" ASC,
  topo2."CellInstanceIdentifier" ASC;
