DROP TABLE IF EXISTS t_voisines3g2g_rank2;

CREATE TABLE t_voisines3g2g_rank2 AS
SELECT DISTINCT
  t_voisines3g3g.rnc, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.primaryscramblingcode_s, 
  t_voisines3g3g.locationareacode_s, 
  t_voisines3g2g.gsmneighbouringcell, 
  t_voisines3g2g.userspecificinfo, 
  t_voisines3g2g.ncc, 
  t_voisines3g2g.bcc, 
  t_voisines3g2g.bcchfrequency, 
  t_voisines3g2g.mobilecountrycode, 
  t_voisines3g2g.mobilenetworkcode, 
  t_voisines3g2g.civ, 
  t_voisines3g2g.lacv, 
  t_voisines3g2g.gsmcellindivoffset, 
  t_voisines3g2g.neighbourcellprio, 
  t_voisines3g2g.qoffset1sn, 
  t_voisines3g2g.qrxlevmin, 
  t_voisines3g2g.rdnid, 
  t_voisines3g2g.sib11ordchusage
FROM 
  public.t_voisines3g2g, 
  public.t_voisines3g3g, 
  public.npo_clashcnlinterrat
WHERE 
  t_voisines3g3g.umtsfddneighbouringcell = t_voisines3g2g.fddcell AND
  npo_clashcnlinterrat."CellName" = t_voisines3g3g.fddcell;
