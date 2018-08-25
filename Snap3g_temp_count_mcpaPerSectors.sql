SELECT 
  t_topologie3g.nodeb, 
  COUNT(t_topologie3g.fddcell)
FROM 
  public.snap3g_antennaaccess, 
  public.snap3g_btscell, 
  public.t_topologie3g
WHERE 
  snap3g_antennaaccess.btsequipment = snap3g_btscell.btsequipment AND
  snap3g_antennaaccess.antennaaccess = snap3g_btscell.antennaaccesslist AND
  snap3g_btscell.btsequipment = t_topologie3g.btsequipment AND
  snap3g_btscell.btscell = t_topologie3g.btscell AND
  dlfrequencynumber = '10787'
GROUP BY
  t_topologie3g.nodeb;
