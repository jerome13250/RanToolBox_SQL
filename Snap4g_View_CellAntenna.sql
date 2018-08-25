SELECT 
  t_topologie4g.enbequipment, 
  t_topologie4g.ltecell, 
  t_topologie4g.eci, 
  t_topologie4g.administrativestate, 
  t_topologie4g.operationalstate, 
  t_topologie4g.availabilitystatus, 
  t_topologie4g.dlbandwidth, 
  t_topologie4g.dlearfcn, 
  snap4g_cellantennaport.cellantennaport, 
  snap4g_cellantennaport.antennaportid, 
  snap4g_cellantennaport.cellantennaportlabel, 
  snap4g_cellantennaport.rxpath, 
  snap4g_cellantennaport.rxusagestate, 
  snap4g_cellantennaport.txpath, 
  snap4g_cellantennaport.txusagestate, 
  snap4g_cellantennaport.ulantennagain, 
  snap4g_antennaport.rxused, 
  snap4g_antennaport.txused, 
  snap4g_antennaport.sectorid, 
  snap4g_antennaport.retsubunitid, 
  snap4g_antennaport.tmasubunitid, 
  snap4g_antennaport.ttlnaequipped, 
  snap4g_antennaport.ttlnaantennagain, 
  snap4g_antennaport.antennagain, 
  snap4g_antennaport.antennagainconfigure, 
  snap4g_antennaport.antennalabel, 
  snap4g_antennaport.antennapathattenuationdl, 
  snap4g_antennaport.antennapathattenuationul, 
  snap4g_antennaport.jumperlossdl, 
  snap4g_antennaport.jumperlossul, 
  snap4g_antennaport.antennapathdelaydl, 
  snap4g_antennaport.antennapathdelaydlmeasured, 
  snap4g_antennaport.antennapathdelayul, 
  snap4g_antennaport.antennapathdelayulmeasured, 
  snap4g_antennaport.antennapathdelayvalueused, 
  snap4g_antennaport.antennapathdeltagroupdelay, 
  snap4g_antennaport.antennapathgaindl, 
  snap4g_antennaport.azimuth, 
  snap4g_antennaport.horizontalbeamwidth, 
  snap4g_antennaport.horizontalbeamwidthconfigure, 
  snap4g_antennaport.verticalbeamwidth, 
  snap4g_antennaport.verticalbeamwidthconfigure
FROM 
  public.t_topologie4g, 
  public.snap4g_cellantennaport, 
  public.snap4g_antennaport
WHERE 
  t_topologie4g.enbequipment = snap4g_cellantennaport.enbequipment AND
  t_topologie4g.ltecell = snap4g_cellantennaport.ltecell AND
  snap4g_cellantennaport.enbequipment = snap4g_antennaport.enbequipment AND
  snap4g_cellantennaport.cpriradioequipment = snap4g_antennaport.cpriradioequipment AND
  snap4g_cellantennaport.antennaport = snap4g_antennaport.antennaport
ORDER BY
  t_topologie4g.ltecell ASC, 
  snap4g_cellantennaport.cellantennaport ASC;
