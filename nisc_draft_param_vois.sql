SELECT 
  t_nisc_adjacency_updated."AdjacencyInstanceIdentifier", 
  topo2g_1."CellName" AS "cellName_s", 
  topo2g_2."CellName" AS "cellName_v", 
  t_nisc_adjacency_updated."EnableTrafficLoadHO", 
  t_nisc_adjacency_updated."HoMargin", 
  t_nisc_adjacency_updated."HoMarginAlcatelDist", 
  t_nisc_adjacency_updated."HoMarginLevel", 
  t_nisc_adjacency_updated."HoMarginQual", 
  t_nisc_adjacency_updated."HoPriorityLevel", 
  t_nisc_adjacency_updated."LRxlevMultibandForceDr", 
  t_nisc_adjacency_updated."L_RXLEV_CPT_HO", 
  t_nisc_adjacency_updated."Linkfactor0n", 
  t_nisc_adjacency_updated."LocationName", 
  t_nisc_adjacency_updated."MaxRxLevNCellHo", 
  t_nisc_adjacency_updated."OUTDOOR_UMB_LEV"
FROM 
  public.t_nisc_adjacency_updated, 
  public.t_topologie2g topo2g_1, 
  public.t_topologie2g topo2g_2
WHERE 
  t_nisc_adjacency_updated.source_cell = topo2g_1."CellInstanceIdentifier" AND
  t_nisc_adjacency_updated."RelatedTargetCell" = topo2g_2."CellInstanceIdentifier"

 LIMIT 100;
