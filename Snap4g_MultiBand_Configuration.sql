SELECT 
  snap4g_ltecell.enbequipment, 
  snap4g_ltecell.ltecell, 
  snap4g_ltecell.administrativestate, 
  snap4g_ltecell.operationalstate, 
  snap4g_ltecell.dedicatedconfid, 
  snap4g_ltecell.enbradioconfid, 
  snap4g_ltecell.enbvoipconfid
FROM 
  public.snap4g_ltecell
ORDER BY
  snap4g_ltecell.ltecell ASC;
