SELECT 
  string_agg(snap3g_alarmprioritytableconfclass.rnc,'-') AS rnc_list, 
  COUNT(snap3g_alarmprioritytableconfclass.rnc) AS rnc_count, 
  snap3g_alarmprioritytableconfclass.radioaccessservice, 
  snap3g_alarmprioritytableconfclass.imcta, 
  snap3g_alarmprioritytableconfclass.alarmprioritytableconfclass, 
  string_agg(snap3g_alarmprioritytableconfclass.userspecificinfo,'-') AS userspecificinfo_list, 
  snap3g_frequency.access, 
  snap3g_frequency.dlfrequencynumber, 
  snap3g_frequency.rdnid, 
  snap3g_frequency.ulfrequencynumber, 
  string_agg(snap3g_frequency.userspecificinfo, '-') AS freq_info_list, 
  snap3g_service.service, 
  snap3g_service.priority, 
  snap3g_service.rdnid 
  --snap3g_service.userspecificinfo
FROM 
  public.snap3g_alarmprioritytableconfclass, 
  public.snap3g_frequency, 
  public.snap3g_service
WHERE 
  snap3g_alarmprioritytableconfclass.rnc = snap3g_frequency.rnc AND
  snap3g_alarmprioritytableconfclass.radioaccessservice = snap3g_frequency.radioaccessservice AND
  snap3g_alarmprioritytableconfclass.imcta = snap3g_frequency.imcta AND
  snap3g_alarmprioritytableconfclass.alarmprioritytableconfclass = snap3g_frequency.alarmprioritytableconfclass AND
  snap3g_frequency.rnc = snap3g_service.rnc AND
  snap3g_frequency.radioaccessservice = snap3g_service.radioaccessservice AND
  snap3g_frequency.imcta = snap3g_service.imcta AND
  snap3g_frequency.alarmprioritytableconfclass = snap3g_service.alarmprioritytableconfclass AND
  snap3g_frequency.frequency = snap3g_service.frequency AND 
  snap3g_alarmprioritytableconfclass.rnc != 'BACKUP_A' AND 
  snap3g_alarmprioritytableconfclass.rnc NOT LIKE 'RS/_%' 
  --AND snap3g_alarmprioritytableconfclass.rnc != 'CLERMONT3'
  --AND snap3g_alarmprioritytableconfclass.alarmprioritytableconfclass = '13'
GROUP BY
  snap3g_alarmprioritytableconfclass.radioaccessservice, 
  snap3g_alarmprioritytableconfclass.imcta, 
  snap3g_alarmprioritytableconfclass.alarmprioritytableconfclass, 
  snap3g_frequency.access, 
  snap3g_frequency.dlfrequencynumber, 
  snap3g_frequency.rdnid, 
  snap3g_frequency.ulfrequencynumber, 
  --snap3g_frequency.userspecificinfo, 
  snap3g_service.service, 
  snap3g_service.priority, 
  snap3g_service.rdnid

ORDER BY
  snap3g_alarmprioritytableconfclass.alarmprioritytableconfclass::int, 
  snap3g_service.service ASC,
  snap3g_frequency.ulfrequencynumber ASC,
  COUNT(snap3g_alarmprioritytableconfclass.rnc) DESC;
