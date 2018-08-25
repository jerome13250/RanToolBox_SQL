SELECT 
  string_agg(snap3g_serviceprioritygeneraltableconfclass.rnc,'-' ORDER BY snap3g_serviceprioritygeneraltableconfclass.rnc) AS rnc_list, 
  count(snap3g_serviceprioritygeneraltableconfclass.rnc) AS rnc_count, 
  snap3g_serviceprioritygeneraltableconfclass.serviceprioritygeneraltableconfclass, 
  string_agg(snap3g_serviceprioritygeneraltableconfclass.userspecificinfo,'-') AS userspecificinfo_list, 
  snap3g_service_2.service,
  snap3g_frequency_2.frequency, 
  snap3g_frequency_2.access, 
  snap3g_frequency_2.dlfrequencynumber, 
  snap3g_frequency_2.rdnid, 
  snap3g_frequency_2.ulfrequencynumber, 
  snap3g_frequency_2.userspecificinfo, 
 
  snap3g_service_2.dcpriority, 
  snap3g_service_2.priority, 
  snap3g_service_2.rdnid, 
  snap3g_service_2.userspecificinfo
FROM 
  public.snap3g_serviceprioritygeneraltableconfclass, 
  public.snap3g_frequency_2, 
  public.snap3g_service_2
WHERE 
  snap3g_serviceprioritygeneraltableconfclass.rnc = snap3g_frequency_2.rnc AND
  snap3g_serviceprioritygeneraltableconfclass.radioaccessservice = snap3g_frequency_2.radioaccessservice AND
  snap3g_serviceprioritygeneraltableconfclass.imcta = snap3g_frequency_2.imcta AND
  snap3g_serviceprioritygeneraltableconfclass.serviceprioritygeneraltableconfclass = snap3g_frequency_2.serviceprioritygeneraltableconfclass AND
  snap3g_frequency_2.rnc = snap3g_service_2.rnc AND
  snap3g_frequency_2.radioaccessservice = snap3g_service_2.radioaccessservice AND
  snap3g_frequency_2.imcta = snap3g_service_2.imcta AND
  snap3g_frequency_2.serviceprioritygeneraltableconfclass = snap3g_service_2.serviceprioritygeneraltableconfclass AND
  snap3g_frequency_2.frequency = snap3g_service_2.frequency
  --AND snap3g_serviceprioritygeneraltableconfclass.rnc = 'TOULON_SF1'
GROUP BY 
  snap3g_serviceprioritygeneraltableconfclass.serviceprioritygeneraltableconfclass, 
  snap3g_frequency_2.frequency, 
  snap3g_frequency_2.access, 
  snap3g_frequency_2.dlfrequencynumber, 
  snap3g_frequency_2.rdnid, 
  snap3g_frequency_2.ulfrequencynumber, 
  snap3g_frequency_2.userspecificinfo, 
  snap3g_service_2.service, 
  snap3g_service_2.dcpriority, 
  snap3g_service_2.priority, 
  snap3g_service_2.rdnid, 
  snap3g_service_2.userspecificinfo

ORDER BY
     snap3g_serviceprioritygeneraltableconfclass.serviceprioritygeneraltableconfclass,
     snap3g_service_2.service,
     snap3g_frequency_2.frequency
     ;