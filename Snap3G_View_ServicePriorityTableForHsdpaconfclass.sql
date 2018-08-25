SELECT 
  snap3g_serviceprioritytableforhsdpaconfclass.rnc, 
  snap3g_serviceprioritytableforhsdpaconfclass.serviceprioritytableforhsdpaconfclass, 
  snap3g_serviceprioritytableforhsdpaconfclass.userspecificinfo, 
  snap3g_frequency_3.frequency, 
  snap3g_frequency_3.access, 
  snap3g_frequency_3.dlfrequencynumber, 
  snap3g_frequency_3.rdnid, 
  snap3g_frequency_3.ulfrequencynumber, 
  snap3g_frequency_3.userspecificinfo, 
  snap3g_service_3.service, 
  snap3g_service_3.dcpriority, 
  snap3g_service_3.priority, 
  snap3g_service_3.rdnid, 
  snap3g_service_3.userspecificinfo
FROM 
  public.snap3g_serviceprioritytableforhsdpaconfclass, 
  public.snap3g_frequency_3, 
  public.snap3g_service_3
WHERE 
  snap3g_serviceprioritytableforhsdpaconfclass.rnc = snap3g_frequency_3.rnc AND
  snap3g_serviceprioritytableforhsdpaconfclass.radioaccessservice = snap3g_frequency_3.radioaccessservice AND
  snap3g_serviceprioritytableforhsdpaconfclass.imcta = snap3g_frequency_3.imcta AND
  snap3g_serviceprioritytableforhsdpaconfclass.serviceprioritytableforhsdpaconfclass = snap3g_frequency_3.serviceprioritytableforhsdpaconfclass AND
  snap3g_frequency_3.rnc = snap3g_service_3.rnc AND
  snap3g_frequency_3.radioaccessservice = snap3g_service_3.radioaccessservice AND
  snap3g_frequency_3.imcta = snap3g_service_3.imcta AND
  snap3g_frequency_3.serviceprioritytableforhsdpaconfclass = snap3g_service_3.serviceprioritytableforhsdpaconfclass AND
  snap3g_frequency_3.frequency = snap3g_service_3.frequency
ORDER BY
  snap3g_serviceprioritytableforhsdpaconfclass.serviceprioritytableforhsdpaconfclass,
  snap3g_service_3.service,
  snap3g_frequency_3.frequency;