DROP TABLE IF EXISTS t_ctn_result_detected;

CREATE TABLE t_ctn_result_detected AS

SELECT 
  --tdistance1.evt_name,
  tdistance1.primarycell, 
  tdistance1.rncs, 
  tdistance1.fddcell, 
  tdistance1.lcids, 
  tdistance1.dlfrequencynumbers, 
  tdistance1.nbvoisintras, 
  tdistance1.psc, 
  tdistance1.average_cpichecno, 
  tdistance1.nb_event, 
  tdistance1.umtsfddneighbouringcell, 
  tdistance1.lcidv, 
  tdistance1.dlfrequencynumberv, 
  tdistance1.nbvoisintrav, 
  tdistance1.distance_km,
  CASE 
	WHEN tdistance2.distance_km < 1.5 * tdistance1.distance_km THEN '! AMBIGUITY !' 
	WHEN tdistance1.distance_km > 20 THEN '! DISTANCE !'
	ELSE '' 
	END AS warning,
  tdistance2.umtsfddneighbouringcell AS umtsfddneighbouringcell_second, 
  tdistance2.lcidv AS lcidv_second, 
  tdistance2.dlfrequencynumberv AS dlfrequencynumberv_second, 
  tdistance2.nbvoisintrav AS nbvoisintrav_second, 
  tdistance2.distance_km AS distance_km_second
FROM 
  public.t_calltraceaggr_scdetected_distance AS tdistance1 INNER JOIN public.t_calltraceaggr_scdetected_distancemin AS tdistancemin1
  ON
	tdistance1.fddcell = tdistancemin1.fddcell AND
	tdistance1.lcids = tdistancemin1.lcids AND
	tdistance1.psc = tdistancemin1.psc AND
	tdistance1.average_cpichecno = tdistancemin1.average_cpichecno AND
	tdistance1.nb_event = tdistancemin1.nb_event AND
	tdistance1.distance_km = tdistancemin1.distance_km
     
  LEFT JOIN public.t_calltraceaggr_scdetected_distance AS tdistance2
  ON 
	tdistance1.fddcell = tdistance2.fddcell AND
	tdistance1.lcids = tdistance2.lcids AND
	tdistance1.psc = tdistance2.psc AND
	tdistance1.average_cpichecno = tdistance2.average_cpichecno AND
	tdistance1.nb_event = tdistance2.nb_event
   
  INNER JOIN public.t_calltraceaggr_scdetected_distancesecondmin AS tdistancemin2
  ON
	tdistance2.fddcell = tdistancemin2.fddcell AND
	tdistance2.lcids = tdistancemin2.lcids AND
	tdistance2.psc = tdistancemin2.psc AND
	tdistance2.average_cpichecno = tdistancemin2.average_cpichecno AND
	tdistance2.nb_event = tdistancemin2.nb_event AND
	tdistance2.distance_km = tdistancemin2.distance_km
  
ORDER BY
  tdistance1.fddcell ASC, 
  tdistance1.nb_event DESC ;
