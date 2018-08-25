SELECT 
  snap3g_remotefddcell.rnc AS "RNC", 
  snap3g_remotefddcell.localcellid AS "LCID",
  snap3g_remotefddcell.remotefddcell AS remotefddcell,
  snap3g_remotefddcell.neighbouringfddcellid AS current_remote_neighbouringfddcellid,
  t_topologie3g.rnc AS rnc_info, 
  'neighbouringFDDCellId'::text as parametre,
  t_topologie3g.cellid  AS valeur
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g
	ON snap3g_remotefddcell.remotefddcell = t_topologie3g.fddcell
  
WHERE 
  t_topologie3g.cellid != snap3g_remotefddcell.neighbouringfddcellid
ORDER BY
  remotefddcell;
