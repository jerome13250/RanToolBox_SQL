DROP TABLE IF EXISTS t_voisines3g3g;

CREATE TABLE t_voisines3g3g AS
SELECT 
  snap3g_umtsfddneighbouringcell.rnc,
  topo_s.rncid AS rncid_s,
  topo_s.nodeb AS nodeb_s,
  snap3g_umtsfddneighbouringcell.fddcell, 
  topo_s.dlfrequencynumber AS dlfrequencynumber_s,
  topo_s.localcellid AS localcellid_s,
  topo_s.cellid AS cellid_s,
  topo_s.primaryscramblingcode AS primaryscramblingcode_s,  
  topo_s.locationareacode AS locationareacode_s,
  topo_s.routingareacode AS routingareacode_s, 
  topo_n.rnc AS rnc_v,
  topo_n.rncid AS rncid_v,
  topo_n.nodeb AS nodeb_v,
  snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell,
  topo_n.dlfrequencynumber AS dlfrequencynumber_v,
  topo_n.localcellid AS localcellid_v,
  topo_n.cellid AS cellid_v,
  topo_n.primaryscramblingcode AS primaryscramblingcode_v,   
  topo_n.locationareacode AS locationareacode_v,
  topo_n.routingareacode AS routingareacode_v,
  snap3g_umtsfddneighbouringcell.sib11ordchusage, 
  snap3g_umtsfddneighbouringcell.umtsneighrelationid, 
  snap3g_umtsneighbouringrelation.maxallowedultxpower,
  snap3g_umtsneighbouringrelation.neighbouringcelloffset,
  snap3g_umtsneighbouringrelation.qoffset1sn,
  snap3g_umtsneighbouringrelation.qoffset2sn,
  --snap3g_umtsneighbouringrelation.qoffsetmbms,
  snap3g_umtsneighbouringrelation.qqualmin,
  snap3g_umtsneighbouringrelation.qrxlevmin
  
FROM 
  public.snap3g_umtsfddneighbouringcell INNER JOIN public.snap3g_umtsneighbouringrelation
  ON snap3g_umtsfddneighbouringcell.rnc = snap3g_umtsneighbouringrelation.rnc AND
     snap3g_umtsfddneighbouringcell.umtsneighrelationid = snap3g_umtsneighbouringrelation.umtsneighbouringrelation
  LEFT JOIN public.t_topologie3g AS topo_s
  ON snap3g_umtsfddneighbouringcell.fddcell = topo_s.fddcell
  LEFT JOIN public.t_topologie3g AS topo_n
  ON snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell = topo_n.fddcell;
  
CREATE INDEX
ON t_voisines3g3g (fddcell);
CREATE INDEX
ON t_voisines3g3g (umtsfddneighbouringcell);
CREATE INDEX
ON t_voisines3g3g (dlfrequencynumber_s);
CREATE INDEX
ON t_voisines3g3g (primaryscramblingcode_s);
CREATE INDEX
ON t_voisines3g3g (dlfrequencynumber_v);
CREATE INDEX
ON t_voisines3g3g (primaryscramblingcode_v);
CREATE INDEX
ON t_voisines3g3g (localcellid_s);
CREATE INDEX
ON t_voisines3g3g (localcellid_v);
