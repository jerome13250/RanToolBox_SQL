DROP TABLE IF EXISTS ctn_evt_aggr_modified;

CREATE TABLE ctn_evt_aggr_modified AS
SELECT 
  ctn_evt_aggr.evt_name, 
  ctn_evt_aggr.primarycell, 
  topo1.rnc AS rncs, 
  topo1.rncid AS rncids, 
  topo1.nodeb AS nodebs, 
  topo1.fddcell, 
  topo1.cellid AS cellids, 
  topo1.dlfrequencynumber AS dlfrequencynumbers, 
  topo1.localcellid AS localcellids, 
  topo1.locationareacode AS locationareacodes, 
  topo1.primaryscramblingcode AS primaryscramblingcodes, 
  topo1.administrativestate AS administrativestates, 
  topo1.operationalstate AS operationalstates, 
  topo1.availabilitystatus AS availabilitystatus,
  topo1.longitude,
  topo1.latitude, 
  topo1.codenidt AS codenidts, 
  ctn_evt_aggr.targetcell, 
  topo2.rnc AS rncv, 
  topo2.rncid AS rncidv, 
  topo2.nodeb AS nodebv, 
  topo2.fddcell AS umtsfddneighbouringcell, 
  topo2.cellid AS cellidv, 
  topo2.dlfrequencynumber AS dlfrequencynumberv, 
  topo2.localcellid AS localcellidv, 
  topo2.locationareacode AS locationareacodev, 
  topo2.primaryscramblingcode AS primaryscramblingcodev, 
  topo2.administrativestate AS administrativestatev, 
  topo2.operationalstate AS operationalstatev, 
  topo2.availabilitystatus AS availabilitystatusv, 
  topo2.codenidt AS codenidtv, 
  ctn_evt_aggr.initaccesscell, 
  ctn_evt_aggr.psc, 
  cpichecno_sum/(nb_event*10) AS Average_cpichEcNo, 
  ctn_evt_aggr.mcc, 
  ctn_evt_aggr.mnc, 
  ctn_evt_aggr.lac, 
  ctn_evt_aggr.ci, 
  t_topologie2gfrom3g.gsmcell, 
  t_topologie2gfrom3g.userspecificinfo, 
  --t_topologie2gfrom3g.gsmbandindicator, 
  ctn_evt_aggr.nb_event
FROM 
  public.ctn_evt_aggr
  LEFT JOIN public.t_topologie3g topo1
  ON 
	ctn_evt_aggr.primarycell = topo1.alcatel_cellcode_ct

  LEFT JOIN public.t_topologie3g topo2
  ON 
	ctn_evt_aggr.targetcell = topo2.alcatel_cellcode_ct
   
  LEFT JOIN public.t_topologie2gfrom3g
  ON
	ctn_evt_aggr.lac = t_topologie2gfrom3g.locationareacode AND
	ctn_evt_aggr.ci = t_topologie2gfrom3g.ci

WHERE
	primaryCell IN 
		(SELECT primaryCell
		FROM ctn_evt_aggr
		WHERE EVT_NAME ='CTN_EVENT_NBAP_RADIO_LINK_SETUP' AND 
		primaryCell<>'' AND
		 primaryCell Is Not Null);
