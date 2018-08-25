DROP TABLE IF EXISTS T_CallTraceAggr_SCDetected_DistanceSecondMin;

CREATE TABLE T_CallTraceAggr_SCDetected_DistanceSecondMin AS
SELECT 
  t_calltraceaggr_scdetected_distance.fddcell, 
  t_calltraceaggr_scdetected_distance.lcids, 
  t_calltraceaggr_scdetected_distance.psc, 
  t_calltraceaggr_scdetected_distance.average_cpichecno, 
  t_calltraceaggr_scdetected_distance.nb_event, 
  min(t_calltraceaggr_scdetected_distance.distance_km) AS distance_km
FROM 
  public.t_calltraceaggr_scdetected_distance LEFT JOIN public.t_calltraceaggr_scdetected_distancemin 
  ON  
  t_calltraceaggr_scdetected_distancemin.fddcell = t_calltraceaggr_scdetected_distance.fddcell AND
  t_calltraceaggr_scdetected_distancemin.lcids = t_calltraceaggr_scdetected_distance.lcids AND
  t_calltraceaggr_scdetected_distancemin.psc = t_calltraceaggr_scdetected_distance.psc AND
  t_calltraceaggr_scdetected_distancemin.average_cpichecno = t_calltraceaggr_scdetected_distance.average_cpichecno AND
  t_calltraceaggr_scdetected_distancemin.nb_event = t_calltraceaggr_scdetected_distance.nb_event AND
  t_calltraceaggr_scdetected_distancemin.distance_km = t_calltraceaggr_scdetected_distance.distance_km
WHERE
  t_calltraceaggr_scdetected_distancemin.fddcell IS NULL
GROUP BY
  t_calltraceaggr_scdetected_distance.fddcell, 
  t_calltraceaggr_scdetected_distance.lcids, 
  t_calltraceaggr_scdetected_distance.psc, 
  t_calltraceaggr_scdetected_distance.average_cpichecno, 
  t_calltraceaggr_scdetected_distance.nb_event
ORDER BY
  fddcell,
  nb_event;
