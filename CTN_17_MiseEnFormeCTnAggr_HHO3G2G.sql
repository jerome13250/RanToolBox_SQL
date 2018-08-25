DROP TABLE IF EXISTS t_CallTraceAggr_HHO3G2G;

CREATE TABLE t_CallTraceAggr_HHO3G2G AS

SELECT 
  evt_name, 
  primarycell, 
  rncs, 
  rncids, 
  fddcell, 
  cellids, 
  dlfrequencynumbers, 
  localcellids AS lcids, 
  locationareacodes, 
  userspecificinfo, 
  gsmcell, 
  mcc, 
  mnc, 
  lac, 
  ci, 
  nb_event
FROM 
  public.ctn_evt_aggr_modified
WHERE 
  gsmcell IS NOT NULL  
ORDER BY
  fddcell ASC,
  nb_event DESC;
