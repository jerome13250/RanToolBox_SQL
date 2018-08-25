DROP TABLE IF EXISTS t_calltraceaggr_nbhho3g2gfailures;

CREATE TABLE t_calltraceaggr_nbhho3g2gfailures AS
SELECT 
  fddcell, 
  gsmcell, 
  nb_event
FROM 
  public.ctn_evt_aggr_modified
WHERE 
 evt_name LIKE 'CTN_EVENT_3G2G_INTERRAT_HO_CS_FAILURE'
;
