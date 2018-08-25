SELECT 
  snap4g_ltecell.enbequipment, 
  count(snap4g_ltecell.enbequipment),
  snap4g_ltecell.ltecellpositionlatitude, 
  snap4g_ltecell.ltecellpositionlongitude, 
  snap4g_frequencyandbandwidthfdd.dlearfcn
FROM 
  public.snap4g_ltecell, 
  public.snap4g_frequencyandbandwidthfdd
WHERE 
  snap4g_ltecell.enbequipment = snap4g_frequencyandbandwidthfdd.enbequipment AND
  snap4g_ltecell.enb = snap4g_frequencyandbandwidthfdd.enb AND
  snap4g_ltecell.ltecell = snap4g_frequencyandbandwidthfdd.ltecell   
GROUP BY
  snap4g_ltecell.enbequipment,
  snap4g_ltecell.ltecellpositionlatitude, 
  snap4g_ltecell.ltecellpositionlongitude, 
  snap4g_frequencyandbandwidthfdd.dlearfcn
HAVING 
  count(snap4g_ltecell.enbequipment) =4
ORDER BY
  snap4g_ltecell.enbequipment ASC;
