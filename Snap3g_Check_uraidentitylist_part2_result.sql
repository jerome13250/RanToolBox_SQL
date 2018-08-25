SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  snap3g_radioaccessservice.pchrrcstates, 
  t_topologie3g.nodeb, 
  t_topologie3g.runningsoftwareversion, 
  t_topologie3g.fddcell, 
  t_topologie3g.cellid, 
  t_topologie3g.dlfrequencynumber, 
  t_topologie3g.localcellid, 
  t_topologie3g.locationareacode, 
  t_topologie3g.routingareacode, 
  t_topologie3g.uraidentitylist, 
  t_uramax_2.uraidentitylist AS max_rnc_uraidentitylist, 
  t_uramax_2.ura_number AS max_rnc_ura_number



FROM 
  public.t_topologie3g LEFT JOIN public.t_uraidentitylist_max_final t_uramax_1
  ON
    t_topologie3g.rnc = t_uramax_1.rnc AND
    t_topologie3g.uraidentitylist = t_uramax_1.uraidentitylist 
  INNER JOIN public.t_uraidentitylist_max_final t_uramax_2
  ON 
    t_topologie3g.rnc = t_uramax_2.rnc
  INNER JOIN public.snap3g_radioaccessservice
  ON
    t_topologie3g.rnc = snap3g_radioaccessservice.rnc
  
WHERE
   t_uramax_1.rnc IS NULL
   AND t_topologie3g.rnc != 'EXTERNAL'
   --AND snap3g_radioaccessservice.pchrrcstates = 'uraPchEnabled'
ORDER BY
  t_topologie3g.rnc,
  t_topologie3g.fddcell;