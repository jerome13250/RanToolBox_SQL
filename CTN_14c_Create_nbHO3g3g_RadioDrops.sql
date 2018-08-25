DROP TABLE IF EXISTS t_calltraceaggr_nbho3g3gdrop;

CREATE TABLE t_calltraceaggr_nbho3g3gdrop AS
SELECT 
  primarycell,
  fddcell, 
  targetcell,
  umtsfddneighbouringcell,
  sum(nb_event) AS nb_ho3g3gdrop
FROM 
  public.ctn_evt_aggr_modified
WHERE 
    evt_name IN 
	('CTN_EVENT_NBAP_RADIO_LINK_FAILURE_INDICATION','CTN_EVENT_RNSAP_RADIO_LINK_FAILURE_INDICATION')

GROUP BY
  primarycell,
  fddcell, 
  targetcell,
  umtsfddneighbouringcell
;
