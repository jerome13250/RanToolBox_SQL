SELECT 
  snap4g_enb.enbequipment, 
  snap4g_enb.cellmappingoverboardmode, 
  snap4g_enbequipment.systemrelease, 
  snap4g_enbequipment.expectedcontrollertype, 
  snap4g_enbequipment.expectedmodemtype, 
  snap4g_activationservice.activationservice, 
  snap4g_activationservice.iscarrieraggregationenabled, 
  snap4g_activationservice.isdualcarrierenabled, 
  snap4g_activationservice.istricarrierenabled, 
  snap4g_ltecell.ltecell, 
  snap4g_ltecell.administrativestate, 
  snap4g_ltecell.operationalstate, 
  snap4g_ltecell.carrieraggregationcellgroup
FROM 
  public.snap4g_activationservice, 
  public.snap4g_enb, 
  public.snap4g_ltecell, 
  public.snap4g_enbequipment
WHERE 
  snap4g_activationservice.enbequipment = snap4g_ltecell.enbequipment AND
  snap4g_activationservice.enb = snap4g_ltecell.enb AND
  snap4g_enb.enbequipment = snap4g_activationservice.enbequipment AND
  snap4g_enb.enb = snap4g_activationservice.enb AND
  snap4g_enbequipment.enbequipment = snap4g_enb.enbequipment AND
  snap4g_activationservice.isdualcarrierenabled LIKE 'true' AND 
  snap4g_activationservice.iscarrieraggregationenabled LIKE 'false' AND
  snap4g_enbequipment.systemrelease NOT LIKE 'LR_13_03'
ORDER BY
  snap4g_ltecell.ltecell ASC;
