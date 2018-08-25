DROP TABLE IF EXISTS T_CallTraceAggr_SCDetected_Distance;

CREATE TABLE T_CallTraceAggr_SCDetected_Distance AS
SELECT 
  --ctn_evt_aggr_modified.evt_name,
  ctn_evt_aggr_modified.primarycell, 
  ctn_evt_aggr_modified.rncs,
  ctn_evt_aggr_modified.fddcell, 
  ctn_evt_aggr_modified.localcellids AS lcids, 
  ctn_evt_aggr_modified.dlfrequencynumbers, 
  nbvois1.nbvoisintra AS nbvoisintras, 
  ctn_evt_aggr_modified.psc, 
  ctn_evt_aggr_modified.average_cpichecno, 
  ctn_evt_aggr_modified.nb_event,
  topo.rnc AS rncv,
  topo.fddcell AS UMTSFddNeighbouringCell, 
  topo.localcellid AS lcidv, 
  topo.dlfrequencynumber AS dlfrequencynumberv, 
  nbvois2.nbvoisintra AS nbvoisintrav,
  round(cast(|/((to_number(ctn_evt_aggr_modified.longitude, '999999999')-to_number(topo.longitude, '999999999')) ^ 2 
	+ (to_number(ctn_evt_aggr_modified.latitude, '999999999')-to_number(topo.latitude, '999999999')) ^ 2) as numeric)/1000,2) AS distance_Km
FROM 
   public.ctn_evt_aggr_modified
   INNER JOIN public.t_topologie3g AS topo
   ON 
		ctn_evt_aggr_modified.psc = topo.primaryscramblingcode AND
		ctn_evt_aggr_modified.dlfrequencynumbers = topo.dlfrequencynumber
   
   LEFT JOIN public.t_calltrace_nbneigbdeclared AS nbvois1
   ON ctn_evt_aggr_modified.fddcell = nbvois1.fddcell
   
   LEFT JOIN public.t_calltrace_nbneigbdeclared AS nbvois2
   ON topo.fddcell = nbvois2.fddcell
WHERE  
   ctn_evt_aggr_modified.evt_name='CTN_EVENT_DETECTED_CELL_REPORT';
