SELECT DISTINCT
  t_voisines3g3g.rnc, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.primaryscramblingcode_s, 
  t_voisines3g3g.locationareacode_s, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.localcellid_v, 
  t_voisines3g3g.primaryscramblingcode_v, 
  t_voisines3g3g.locationareacode_v, 
  topo1.administrativestate, 
  topo1.operationalstate, 
  topo1.availabilitystatus, 
  tnbho3g3grequest1.nb_ho3g3grequest,
  tnbho3g3grequest2.nb_ho3g3grequest AS nb_ho3g3grequest_inv
FROM 
  public.t_voisines3g3g 
  INNER JOIN public.t_topologie3g AS topo1
	ON
		t_voisines3g3g.umtsfddneighbouringcell = topo1.fddcell
  LEFT JOIN  public.t_calltraceaggr_nbho3g3grequest AS tnbho3g3grequest1
	ON
		t_voisines3g3g.fddcell = tnbho3g3grequest1.fddcell AND
		t_voisines3g3g.umtsfddneighbouringcell = tnbho3g3grequest1.umtsfddneighbouringcell
  LEFT JOIN public.t_calltraceaggr_nbho3g3grequest AS tnbho3g3grequest2
	ON 
		t_voisines3g3g.umtsfddneighbouringcell = tnbho3g3grequest2.fddcell AND
		t_voisines3g3g.fddcell = tnbho3g3grequest2.umtsfddneighbouringcell
  INNER JOIN public.t_topologie3g AS topo2
	ON
		t_voisines3g3g.fddcell = topo2.fddcell

WHERE 
	t_voisines3g3g.dlfrequencynumber_s = t_voisines3g3g.dlfrequencynumber_v AND
	--t_voisines3g3g.dlfrequencynumber_s IN ('10787','3011') AND
	tnbho3g3grequest1.nb_ho3g3grequest IS NULL AND
	t_voisines3g3g.fddcell IN 
		(SELECT DISTINCT fddcell
		FROM ctn_evt_aggr_modified)
	

ORDER BY
  fddcell ASC,
  umtsfddneighbouringcell ASC
  ;