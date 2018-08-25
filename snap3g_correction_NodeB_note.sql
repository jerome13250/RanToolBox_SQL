SELECT DISTINCT
  snap3g_nodeb.rnc, 
  snap3g_nodeb.nodeb, 
  snap3g_nodeb.note, 
  t_topologie3g.codenidt
FROM 
  public.snap3g_nodeb, 
  public.t_topologie3g
WHERE 
  snap3g_nodeb.nodeb = t_topologie3g.nodeb AND
  (note = 'unset' OR note != t_topologie3g.codenidt)
ORDER BY
  snap3g_nodeb.rnc,
  snap3g_nodeb.nodeb;
