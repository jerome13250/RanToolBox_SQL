SELECT 
  snap4g_carrieraggregationsecondaryconf.enbequipment, 
  snap4g_carrieraggregationsecondaryconf.ltecell, 
  snap4g_activationservice.iscarrieraggregationenabled, 
  snap4g_carrieraggregationsecondaryconf.secondarycellid
FROM 
  public.snap4g_activationservice, 
  public.snap4g_carrieraggregationsecondaryconf
WHERE 
  snap4g_activationservice.enbequipment = snap4g_carrieraggregationsecondaryconf.enbequipment
ORDER BY
  snap4g_carrieraggregationsecondaryconf.ltecell ASC;
