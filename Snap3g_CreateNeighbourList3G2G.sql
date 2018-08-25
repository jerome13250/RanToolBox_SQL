DROP TABLE IF EXISTS t_voisines3g2g;

CREATE TABLE t_voisines3g2g AS
SELECT 
  snap3g_gsmneighbouringcell.rnc, 
  snap3g_gsmneighbouringcell.nodeb, 
  snap3g_gsmneighbouringcell.fddcell, 
  t_topologie3g.cellid, 
  t_topologie3g.dlfrequencynumber, 
  t_topologie3g.localcellid, 
  t_topologie3g.locationareacode, 
  t_topologie3g.codenidt, 
  t_topologie3g.administrativestate, 
  t_topologie3g.operationalstate, 
  t_topologie3g.availabilitystatus, 
  snap3g_gsmcell.gsmcell, 
  snap3g_gsmcell.userspecificinfo, 
  snap3g_gsmcell.ncc,
  snap3g_gsmcell.bcc, 
  snap3g_gsmcell.bcchfrequency, 
  snap3g_gsmcell.ci AS civ, 
  snap3g_gsmcell.gsmbandindicator, 
  snap3g_gsmcell.locationareacode AS lacv, 
  snap3g_gsmcell.maxallowedultxpower, 
  snap3g_gsmcell.mobilecountrycode, 
  snap3g_gsmcell.mobilenetworkcode,  
  snap3g_gsmcell.rdnid, 
  snap3g_gsmcell.gsmneighbourconfclassid,
  snap3g_gsmneighbouringcell.gsmneighbouringcell,
  snap3g_gsmneighbouringcell.gsmcellindivoffset,
  snap3g_gsmneighbouringcell.gsmcelllink,
  snap3g_gsmneighbouringcell.neighbourcellprio,
  snap3g_gsmneighbouringcell.qoffset1sn,
  snap3g_gsmneighbouringcell.qrxlevmin,
  snap3g_gsmneighbouringcell.sib11ordchusage
FROM 
  public.snap3g_gsmneighbouringcell, 
  public.snap3g_gsmcell, 
  public.t_topologie3g
WHERE 
  snap3g_gsmneighbouringcell.rnc = snap3g_gsmcell.rnc AND
  snap3g_gsmneighbouringcell.gsmneighbouringcell = snap3g_gsmcell.gsmcell AND
  snap3g_gsmneighbouringcell.rnc = t_topologie3g.rnc AND
  snap3g_gsmneighbouringcell.fddcell = t_topologie3g.fddcell;
