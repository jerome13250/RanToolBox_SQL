SELECT 
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.isecnocheckfor3gtwincellallowed,
  tmp_topo3g_mar.mar_list
FROM 
  public.snap3g_fddcell INNER JOIN public.tmp_topo3g_mar
ON 
  snap3g_fddcell.fddcell = tmp_topo3g_mar.fddcell
WHERE
  snap3g_fddcell.isecnocheckfor3gtwincellallowed <> tmp_topo3g_mar.mar_list
ORDER BY
  snap3g_fddcell.fddcell;
