DROP TABLE IF EXISTS T_CallTraceAggr_SCDetected_DistanceMin;

CREATE TABLE T_CallTraceAggr_SCDetected_DistanceMin AS
SELECT 
  fddcell, 
  lcids, 
  psc, 
  average_cpichecno, 
  nb_event, 
  min(t_calltraceaggr_scdetected_distance.distance_km) AS distance_km
FROM 
  public.t_calltraceaggr_scdetected_distance
GROUP BY
  fddcell, 
  lcids, 
  psc, 
  average_cpichecno, 
  nb_event
ORDER BY
  fddcell,
  nb_event
;
