SELECT DISTINCT
  topo1.rnc, 
  topo1.rncid, 
  topo1.nodeb, 
  topo1.systemrelease, 
  topo1.fddcell, 
  nodeb1.note AS nidt1, 
  topo1.dlfrequencynumber, 
  topo1.localcellid, 
  topo1.mobilecountrycode, 
  topo1.mobilenetworkcode, 
  topo1.administrativestate, 
  topo1.operationalstate, 
  topo1.availabilitystatus, 
  topo1.cellselectionprofileid, 
  topo2.nodeb, 
  --topo2.fddcell, 
  nodeb2.note AS nidt2, 
  topo2.dlfrequencynumber, 
  --topo2.localcellid, 
  topo2.administrativestate, 
  topo2.operationalstate, 
  topo2.availabilitystatus
FROM 
  public.t_topologie3g topo1, 
  public.t_topologie3g topo2, 
  public.snap3g_nodeb nodeb1, 
  public.snap3g_nodeb nodeb2
WHERE 
  topo1.cellselectionprofileid = '2' AND
  topo1.dlfrequencynumber = '3011' AND
  topo2.dlfrequencynumber = '10787' AND
  --nodeb1.note LIKE'%V1' AND
  
  topo1.nodeb = nodeb1.nodeb AND
  nodeb1.note = nodeb2.note AND
  nodeb2.nodeb = topo2.nodeb
ORDER BY
  topo1.fddcell;
