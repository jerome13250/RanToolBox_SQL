DROP TABLE IF EXISTS t_nisc_adjacency_updated;

CREATE TABLE t_nisc_adjacency_updated AS

SELECT 
  *,
   replace(substring(nisc_adjacency."AdjacencyInstanceIdentifier", '{ applicationID.*, targetCell'),', targetCell','') AS source_cell

FROM 
  public.nisc_adjacency
;