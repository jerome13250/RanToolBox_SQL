DROP TABLE IF EXISTS t_ctn_autoplan_sho;
CREATE TABLE t_ctn_autoplan_sho AS
SELECT 
  topo1.rnc AS rncs, 
  topo1.rncid AS rncids, 
  topo1.codenidt AS codenidts, 
  t_ctn_autoplan_nbshoplusdetected.fddcell, 
  topo1.cellid AS cellids, 
  topo1.dlfrequencynumber AS dlfrequencynumbers, 
  topo1.localcellid AS lcids, 
  topo1.administrativestate AS administrativestates,
  topo1.operationalstate AS operationalstates,
  t_calltrace_nbneigbdeclared1.nbvoisintra AS nbvoisintras, 
  topo2.rnc, 
  topo2.rncid, 
  topo2.codenidt, 
  t_ctn_autoplan_nbshoplusdetected.umtsfddneighbouringcell, 
  topo2.cellid, 
  topo2.dlfrequencynumber, 
  topo2.localcellid AS lcidv, 
  topo2.administrativestate,
  topo2.operationalstate,
  t_calltrace_nbneigbdeclared2.nbvoisintra,
  t_ctn_autoplan_nbshoplusdetected.nbshoplusdetected, 
  t_ctn_result_sho.nb_ho3g3gsuccess, 
  t_ctn_result_sho.neighbor_type, 
  t_ctn_result_detected.nb_event AS nb_evt_detected,
  t_ctn_result_detected.distance_km,
  t_ctn_result_detected.warning,
  t_ctn_result_detected.umtsfddneighbouringcell_second,
  t_ctn_result_detected.lcidv_second,
  t_ctn_result_detected.dlfrequencynumberv_second,
  t_ctn_result_detected.nbvoisintrav_second,
  t_ctn_result_detected.distance_km_second
FROM 
  public.t_ctn_autoplan_nbshoplusdetected
   LEFT JOIN public.t_ctn_result_sho
	ON
	t_ctn_autoplan_nbshoplusdetected.fddcell = t_ctn_result_sho.fddcell AND
  	t_ctn_autoplan_nbshoplusdetected.umtsfddneighbouringcell = t_ctn_result_sho.umtsfddneighbouringcell
  LEFT JOIN public.t_ctn_result_detected
	ON
	t_ctn_autoplan_nbshoplusdetected.fddcell = t_ctn_result_detected.fddcell AND
  	t_ctn_autoplan_nbshoplusdetected.umtsfddneighbouringcell = t_ctn_result_detected.umtsfddneighbouringcell
  LEFT JOIN public.t_topologie3g AS topo1
  	ON
	t_ctn_autoplan_nbshoplusdetected.fddcell = topo1.fddcell
  LEFT JOIN public.t_topologie3g AS topo2
	ON
	t_ctn_autoplan_nbshoplusdetected.umtsfddneighbouringcell = topo2.fddcell
  LEFT JOIN public.t_calltrace_nbneigbdeclared AS t_calltrace_nbneigbdeclared1
	ON
	t_ctn_autoplan_nbshoplusdetected.fddcell = t_calltrace_nbneigbdeclared1.fddcell
  LEFT JOIN public.t_calltrace_nbneigbdeclared AS t_calltrace_nbneigbdeclared2
	ON
	t_ctn_autoplan_nbshoplusdetected.umtsfddneighbouringcell = t_calltrace_nbneigbdeclared2.fddcell
WHERE
  topo1.dlfrequencynumber IN ('10787','3011') --Seulement frequence avec CS
  AND topo1.dlfrequencynumber = topo2.dlfrequencynumber --Iso frequence pour Intra Freq
  AND topo1.operationalstate != 'disabled' --Empeche de prendre en compte une cellule primarycell testee puis eteinte pendant la trace
  AND (
	( neighbor_type = 'NEIGHBOR' AND nbshoplusdetected > 0) -- Garde toutes les voisines dont les flux sont superieurs a 0
	OR ( neighbor_type != 'NEIGHBOR' AND nbshoplusdetected > 20) --Ne rajoute que les voisines CNL et Detected avec plus de 20 flux
	OR ( neighbor_type IS NULL AND nbshoplusdetected > 20) --Rajoute les voisines Detected superieures a 20
	OR nbshoplusdetected >= 1000000 --Copie de force les voisines qui sont HS
	)

ORDER BY
  fddcell,
  nbshoplusdetected DESC;

  
