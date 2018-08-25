SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.provisionedsystemrelease, 
  t_topologie3g.nodeb, 
  t_topologie3g.runningsoftwareversion, 
  t_topologie3g.fddcell, 
  t_topologie3g.cellid, 
  t_topologie3g.localcellid, 
  t_topologie3g.dlfrequencynumber, 
  snap3g_antennaaccess.antennaaccess, 
  snap3g_antennaaccess.tmaaccesstype
FROM 
  public.snap3g_antennaaccess, 
  public.snap3g_btscell, 
  public.t_topologie3g
WHERE 
  snap3g_antennaaccess.btsequipment = snap3g_btscell.btsequipment AND
  snap3g_antennaaccess.antennaaccess = snap3g_btscell.antennaaccesslist AND
  snap3g_btscell.btsequipment = t_topologie3g.btsequipment AND
  snap3g_btscell.btscell = t_topologie3g.btscell;
