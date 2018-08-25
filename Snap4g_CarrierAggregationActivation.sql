SELECT 
  snap4g_enb.enbequipment, 
  snap4g_activationservice.isdualcarrierenabled, 
  snap4g_activationservice.istricarrierenabled, 
  snap4g_enb.cellmappingoverboardmode, 
  snap4g_activationservice.iscarrieraggregationenabled, 
  snap4g_ltecell.ltecell, 
  snap4g_ltecell.administrativestate, 
  snap4g_ltecell.operationalstate, 
  snap4g_ltecell.carrieraggregationcellgroup,
  snap4g_ltecell.pcellusingthisltecellasscell,
  snap4g_ltecell.mainantennaconfiguredpositionlatitude, 
  snap4g_ltecell.mainantennaconfiguredpositionlongitude, 
  snap4g_ltecell.spare5
FROM 
  public.snap4g_enb, 
  public.snap4g_activationservice, 
  public.snap4g_ltecell
WHERE 
  snap4g_enb.enbequipment = snap4g_activationservice.enbequipment AND
  snap4g_activationservice.enbequipment = snap4g_ltecell.enbequipment
ORDER BY
  snap4g_ltecell.ltecell ASC;
