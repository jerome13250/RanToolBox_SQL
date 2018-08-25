SELECT 
  snap4g_cpriradioequipment.enbequipment, 
  snap4g_cpriradioequipment.cpriradioequipment, 
  snap4g_cpriradioequipment.rfmtype, 
  snap4g_cpriradioequipment.fruid, 
  snap4g_cpriradioequipment.localcellpowerlimit, 
  snap4g_cpriradioequipment.locationidentifier, 
  snap4g_cpriradioequipment.primarycpriport, 
  snap4g_cpriradioequipment.primarycprislot, 
  snap4g_cpriradioequipment.secondarycpriport, 
  snap4g_cpriradioequipment.secondarycprislot, 
  snap4g_cpriradioequipment.rfmlicensedtransmitmode, 
  snap4g_cpriradioequipment.rfmcontrolmode, 
  snap4g_cpriradioequipment.remotecontrollerid
FROM 
  public.snap4g_cpriradioequipment
ORDER BY
  snap4g_cpriradioequipment.enbequipment ASC, 
  snap4g_cpriradioequipment.cpriradioequipment ASC;
