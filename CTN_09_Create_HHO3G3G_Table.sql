DROP TABLE IF EXISTS t_calltraceaggr_hho3g3g;

CREATE TABLE t_calltraceaggr_hho3g3g AS
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
  dlfrequencynumbers <> dlfrequencynumberv;
