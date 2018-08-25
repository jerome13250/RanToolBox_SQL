DROP TABLE IF EXISTS t_CallTraceAggr_SHO;

CREATE TABLE t_CallTraceAggr_SHO AS
SELECT 
  evt_name, 
  primarycell, 
  rncs, 
  fddcell, 
  localcellids AS lcids, 
  dlfrequencynumbers, 
  targetcell, 
  rncv, 
  umtsfddneighbouringcell, 
  localcellidv  AS lcidv, 
  dlfrequencynumberv,
  nb_event
FROM 
  public.ctn_evt_aggr_modified
WHERE 
  primarycell <> targetcell AND 
  dlfrequencynumbers = dlfrequencynumberv AND
  UMTSFddNeighbouringCell IS NOT NULL;
