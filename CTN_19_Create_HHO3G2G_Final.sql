DROP TABLE IF EXISTS t_ctn_result_hho3g2g;

CREATE TABLE t_ctn_result_hho3g2g AS

SELECT 
  ctn_evt_aggr_modified.rncs, 
  ctn_evt_aggr_modified.rncids, 
  ctn_evt_aggr_modified.fddcell, 
  ctn_evt_aggr_modified.cellids, 
  ctn_evt_aggr_modified.dlfrequencynumbers, 
  ctn_evt_aggr_modified.localcellids, 
  ctn_evt_aggr_modified.locationareacodes, 
  ctn_evt_aggr_modified.userspecificinfo, 
  ctn_evt_aggr_modified.gsmcell, 
  ctn_evt_aggr_modified.mcc, 
  ctn_evt_aggr_modified.mnc, 
  ctn_evt_aggr_modified.lac, 
  ctn_evt_aggr_modified.ci,
  ctn_evt_aggr_modified.nb_event AS nb_hho3g2g_request,
  t_calltraceaggr_nbhho3g2gfailures.nb_event AS nb_hho3g2g_failure,
  ctn_evt_aggr_modified.nb_event - COALESCE(t_calltraceaggr_nbhho3g2gfailures.nb_event,0) AS nb_hho3g2g_success, 
  CASE WHEN snap3g_gsmneighbouringcell.gsmneighbouringcell IS NULL THEN 'CNL' ELSE 'NEIGHBOR' END AS neighbor_type
FROM 
  public.ctn_evt_aggr_modified 
  LEFT JOIN public.snap3g_gsmneighbouringcell
  ON
	ctn_evt_aggr_modified.fddcell = snap3g_gsmneighbouringcell.fddcell AND
	ctn_evt_aggr_modified.gsmcell = snap3g_gsmneighbouringcell.gsmneighbouringcell
  LEFT JOIN public.t_calltraceaggr_nbhho3g2gfailures
  ON 
	ctn_evt_aggr_modified.fddcell = t_calltraceaggr_nbhho3g2gfailures.fddcell AND
	ctn_evt_aggr_modified.gsmcell = t_calltraceaggr_nbhho3g2gfailures.gsmcell
WHERE
  evt_name = 'CTN_EVENT_3G2G_INTERRAT_HO_CS' 
ORDER BY
  ctn_evt_aggr_modified.fddcell ASC,
  nb_hho3g2g_success DESC ;
