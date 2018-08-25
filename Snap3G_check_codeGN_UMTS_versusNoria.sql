SELECT 
  snap3g_nodeb.rnc, 
  snap3g_nodeb.nodeb, 
  snap3g_nodeb.note, 
  t_topologie3g.codenidt,
  COUNT(t_topologie3g.codenidt),
  string_agg(t_topologie3g.fddcell,'-')
FROM 
  public.snap3g_nodeb INNER JOIN public.t_topologie3g
  ON
  t_topologie3g.nodeb = snap3g_nodeb.nodeb
WHERE
  note != codenidt AND snap3g_nodeb.nodeb NOT LIKE '%BBU%' --exclusion des ROF
GROUP BY 
  snap3g_nodeb.rnc, 
  snap3g_nodeb.nodeb, 
  snap3g_nodeb.note,
  t_topologie3g.codenidt
ORDER BY 
  snap3g_nodeb.nodeb,
  t_topologie3g.codenidt;
