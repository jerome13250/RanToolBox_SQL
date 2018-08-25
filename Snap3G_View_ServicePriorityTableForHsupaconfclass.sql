SELECT 
  string_agg(snap3g_serviceprioritytableforhsupaconfclass.rnc,'-'),
  count(snap3g_serviceprioritytableforhsupaconfclass.rnc),  
  snap3g_serviceprioritytableforhsupaconfclass.serviceprioritytableforhsupaconfclass, 
  string_agg(snap3g_serviceprioritytableforhsupaconfclass.userspecificinfo,'-'),
  snap3g_frequency_4.frequency, 
  snap3g_frequency_4.access, 
  snap3g_frequency_4.dlfrequencynumber, 
  snap3g_frequency_4.rdnid, 
  snap3g_frequency_4.ulfrequencynumber, 
  snap3g_frequency_4.userspecificinfo, 
  snap3g_service_4.service, 
  snap3g_service_4.dcpriority, 
  snap3g_service_4.priority, 
  snap3g_service_4.rdnid, 
  snap3g_service_4.userspecificinfo
FROM 
  public.snap3g_serviceprioritytableforhsupaconfclass, 
  public.snap3g_frequency_4, 
  public.snap3g_service_4
WHERE 
  snap3g_serviceprioritytableforhsupaconfclass.rnc = snap3g_frequency_4.rnc AND
  snap3g_serviceprioritytableforhsupaconfclass.radioaccessservice = snap3g_frequency_4.radioaccessservice AND
  snap3g_serviceprioritytableforhsupaconfclass.imcta = snap3g_frequency_4.imcta AND
  snap3g_serviceprioritytableforhsupaconfclass.serviceprioritytableforhsupaconfclass = snap3g_frequency_4.serviceprioritytableforhsupaconfclass AND
  snap3g_frequency_4.rnc = snap3g_service_4.rnc AND
  snap3g_frequency_4.radioaccessservice = snap3g_service_4.radioaccessservice AND
  snap3g_frequency_4.imcta = snap3g_service_4.imcta AND
  snap3g_frequency_4.serviceprioritytableforhsupaconfclass = snap3g_service_4.serviceprioritytableforhsupaconfclass AND
  snap3g_frequency_4.frequency = snap3g_service_4.frequency
  AND snap3g_serviceprioritytableforhsupaconfclass.rnc = 'MARSEJOL1'
GROUP BY
  snap3g_serviceprioritytableforhsupaconfclass.serviceprioritytableforhsupaconfclass, 
  snap3g_frequency_4.frequency, 
  snap3g_frequency_4.access, 
  snap3g_frequency_4.dlfrequencynumber, 
  snap3g_frequency_4.rdnid, 
  snap3g_frequency_4.ulfrequencynumber, 
  snap3g_frequency_4.userspecificinfo, 
  snap3g_service_4.service, 
  snap3g_service_4.dcpriority, 
  snap3g_service_4.priority, 
  snap3g_service_4.rdnid, 
  snap3g_service_4.userspecificinfo

ORDER BY
  snap3g_serviceprioritytableforhsupaconfclass.serviceprioritytableforhsupaconfclass,
  snap3g_service_4.service,
  snap3g_frequency_4.frequency;