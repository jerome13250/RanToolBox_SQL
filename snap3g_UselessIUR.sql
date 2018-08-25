SELECT DISTINCT
  snap3g_neighbouringrnc.rnc, 
  snap3g_neighbouringrnc.neighbouringrnc, 
  snap3g_neighbouringrnc.administrativestate
FROM 
  public.snap3g_neighbouringrnc LEFT JOIN public.t_voisines3g3g
  ON
  snap3g_neighbouringrnc.rnc = t_voisines3g3g.rnc AND
  snap3g_neighbouringrnc.neighbouringrnc = t_voisines3g3g.rncid_v
WHERE
  t_voisines3g3g.rncid_v IS NULL
ORDER BY
  snap3g_neighbouringrnc.rnc;
