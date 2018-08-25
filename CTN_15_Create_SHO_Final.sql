DROP TABLE IF EXISTS t_ctn_result_sho;

CREATE TABLE t_ctn_result_sho AS

SELECT DISTINCT
  tsho.primarycell, 
  tsho.rncs, 
  tsho.fddcell, 
  tsho.lcids, 
  tsho.dlfrequencynumbers, 
  tnbrvois1.nbvoisintra AS nbvoisintras, 
  tsho.targetcell, 
  tsho.rncv, 
  tsho.umtsfddneighbouringcell, 
  tsho.lcidv, 
  tsho.dlfrequencynumberv, 
  tnbrvois2.nbvoisintra AS nbvoisintrav, 
  COALESCE(tnbho3g3grequest1.nb_ho3g3grequest,0) - COALESCE(tnbho3g3gfailure.nb_ho3g3gfailure,0) AS nb_ho3g3gsuccess,
  tnbho3g3gfailure.nb_ho3g3gfailure,
  tnbho3g3gdrop.nb_ho3g3gdrop,
  tnbho3g3grequest2.nb_ho3g3grequest AS nb_ho3g3grequest_inv, 
  CASE WHEN t_voisines3g3g.umtsfddneighbouringcell IS NULL THEN 'CNL' ELSE 'NEIGHBOR' END AS neighbor_type
FROM 
  public.t_calltraceaggr_sho AS tsho 
  LEFT JOIN public.t_calltraceaggr_nbho3g3grequest AS tnbho3g3grequest1
	ON
	tsho.primarycell = tnbho3g3grequest1.primarycell AND
	tsho.targetcell = tnbho3g3grequest1.targetcell

  LEFT JOIN public.t_calltraceaggr_nbho3g3gfailure AS tnbho3g3gfailure
	ON
	tsho.primarycell = tnbho3g3gfailure.primarycell AND
	tsho.targetcell = tnbho3g3gfailure.targetcell

  LEFT JOIN public.t_calltraceaggr_nbho3g3gdrop AS tnbho3g3gdrop
	ON
	tsho.primarycell = tnbho3g3gdrop.primarycell AND
	tsho.targetcell = tnbho3g3gdrop.targetcell

  LEFT JOIN public.t_voisines3g3g
	ON
	tsho.fddcell = t_voisines3g3g.fddcell AND
	tsho.umtsfddneighbouringcell = t_voisines3g3g.umtsfddneighbouringcell

  LEFT JOIN public.t_calltraceaggr_nbho3g3grequest AS tnbho3g3grequest2
	ON
	tsho.primarycell = tnbho3g3grequest2.targetcell AND
	tsho.targetcell = tnbho3g3grequest2.primarycell

  LEFT JOIN public.t_calltrace_nbneigbdeclared AS tnbrvois1
	ON
	tsho.fddcell = tnbrvois1.fddcell

  LEFT JOIN public.t_calltrace_nbneigbdeclared AS tnbrvois2 
	ON
	tsho.umtsfddneighbouringcell = tnbrvois2.fddcell

ORDER BY
  tsho.fddcell ASC,
  nb_ho3g3gsuccess DESC;
