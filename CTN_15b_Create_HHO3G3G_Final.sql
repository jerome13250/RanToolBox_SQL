DROP TABLE IF EXISTS t_ctn_result_hho3g3g;

CREATE TABLE t_ctn_result_hho3g3g AS

SELECT DISTINCT
  thho3g3g.primarycell, 
  thho3g3g.rncs, 
  thho3g3g.fddcell, 
  thho3g3g.lcids, 
  thho3g3g.dlfrequencynumbers, 
  tnbrvois1.nbvoisinter AS nbvoisinters, 
  thho3g3g.targetcell, 
  thho3g3g.rncv, 
  thho3g3g.umtsfddneighbouringcell, 
  thho3g3g.lcidv, 
  thho3g3g.dlfrequencynumberv, 
  tnbrvois2.nbvoisinter AS nbvoisinterv, 
  COALESCE(tnbho3g3grequest1.nb_ho3g3grequest,0) - COALESCE(tnbho3g3gfailure.nb_ho3g3gfailure,0) AS nb_ho3g3gsuccess,
  tnbho3g3gfailure.nb_ho3g3gfailure,
  tnbho3g3gdrop.nb_ho3g3gdrop,
  tnbho3g3grequest2.nb_ho3g3grequest AS nb_ho3g3grequest_inv, 
  CASE WHEN t_voisines3g3g.umtsfddneighbouringcell IS NULL THEN 'CNL' ELSE 'NEIGHBOR' END AS neighbor_type
FROM 
  public.t_calltraceaggr_hho3g3g AS thho3g3g 
  LEFT JOIN public.t_calltraceaggr_nbho3g3grequest AS tnbho3g3grequest1
	ON
	thho3g3g.primarycell = tnbho3g3grequest1.primarycell AND
	thho3g3g.targetcell = tnbho3g3grequest1.targetcell

  LEFT JOIN public.t_calltraceaggr_nbho3g3gfailure AS tnbho3g3gfailure
	ON
	thho3g3g.primarycell = tnbho3g3gfailure.primarycell AND
	thho3g3g.targetcell = tnbho3g3gfailure.targetcell

  LEFT JOIN public.t_calltraceaggr_nbho3g3gdrop AS tnbho3g3gdrop
	ON
	thho3g3g.primarycell = tnbho3g3gdrop.primarycell AND
	thho3g3g.targetcell = tnbho3g3gdrop.targetcell

  LEFT JOIN public.t_voisines3g3g
	ON
	thho3g3g.fddcell = t_voisines3g3g.fddcell AND
	thho3g3g.umtsfddneighbouringcell = t_voisines3g3g.umtsfddneighbouringcell

  LEFT JOIN public.t_calltraceaggr_nbho3g3grequest AS tnbho3g3grequest2
	ON
	thho3g3g.primarycell = tnbho3g3grequest2.targetcell AND
	thho3g3g.targetcell = tnbho3g3grequest2.primarycell

  LEFT JOIN public.t_calltrace_nbneigbdeclaredinter AS tnbrvois1
	ON
	thho3g3g.fddcell = tnbrvois1.fddcell

  LEFT JOIN public.t_calltrace_nbneigbdeclaredinter AS tnbrvois2 
	ON
	thho3g3g.umtsfddneighbouringcell = tnbrvois2.fddcell

ORDER BY
  thho3g3g.fddcell ASC,
  nb_ho3g3gsuccess DESC;
