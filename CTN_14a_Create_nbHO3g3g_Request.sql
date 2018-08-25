DROP TABLE IF EXISTS t_calltraceaggr_nbho3g3grequest;

CREATE TABLE t_calltraceaggr_nbho3g3grequest AS
SELECT 
  primarycell,
  fddcell, 
  targetcell,
  umtsfddneighbouringcell,
  sum(nb_event) AS nb_ho3g3grequest
FROM 
  public.ctn_evt_aggr_modified
WHERE 
    evt_name IN 
	('CTN_EVENT_NBAP_RADIO_LINK_ADDITION','CTN_EVENT_RNSAP_RADIO_LINK_ADDITION','CTN_EVENT_INTERFREQUENCY_HO')
    AND targetcell IS NOT NULL
GROUP BY
  primarycell,
  fddcell, 
  targetcell,
  umtsfddneighbouringcell
;
