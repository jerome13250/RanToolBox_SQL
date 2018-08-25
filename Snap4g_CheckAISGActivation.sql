SELECT 
  snap4g_enbequipment.enbequipment, 
  snap4g_enbequipment.administrativestate, 
  snap4g_enbequipment.operationalstate, 
  snap4g_enbequipment.availabilitystatus, 
  snap4g_enbequipment.aldscanenable, 
  snap4g_activationservice.isaisgallowed
FROM 
  public.snap4g_enbequipment, 
  public.snap4g_activationservice
WHERE 
  snap4g_enbequipment.enbequipment = snap4g_activationservice.enbequipment
  AND 
  (snap4g_enbequipment.aldscanenable NOT LIKE 'true'
  OR
  snap4g_activationservice.isaisgallowed NOT LIKE 'true')
ORDER BY
  snap4g_enbequipment.enbequipment ASC;
