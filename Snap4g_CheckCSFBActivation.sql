SELECT 
  snap4g_utrafddneighboringfreqconf.enbequipment, 
  snap4g_utrafddneighboringfreqconf.enb, 
  snap4g_utrafddneighboringfreqconf.ltecell, 
  snap4g_utrafddneighboringfreqconf.utraneighboring, 
  snap4g_utrafddneighboringfreqconf.utrafddneighboringfreqconf, 
  snap4g_utrafddneighboringfreqconf.anrstate, 
  snap4g_utrafddneighboringfreqconf.bandutrafdd, 
  snap4g_utrafddneighboringfreqconf.carrierfreq, 
  snap4g_utrafddneighboringfreqconf.hnbpcilist, 
  snap4g_utrafddneighboringfreqconf.preventiveoffloadlink, 
  snap4g_servicetypepriorityconf_1.servicetypepriorityconf, 
  snap4g_servicetypepriorityconf_1.servicetype, 
  snap4g_servicetypepriorityconf_1.emctapriority
FROM 
  public.snap4g_utrafddneighboringfreqconf, 
  public.snap4g_servicetypepriorityconf_1
WHERE 
  snap4g_utrafddneighboringfreqconf.ltecell = snap4g_servicetypepriorityconf_1.ltecell AND
  snap4g_utrafddneighboringfreqconf.utraneighboring = snap4g_servicetypepriorityconf_1.utraneighboring AND
  snap4g_utrafddneighboringfreqconf.utrafddneighboringfreqconf = snap4g_servicetypepriorityconf_1.utrafddneighboringfreqconf

ORDER BY
  snap4g_utrafddneighboringfreqconf.ltecell, 
  snap4g_utrafddneighboringfreqconf.utraneighboring, 
  snap4g_utrafddneighboringfreqconf.utrafddneighboringfreqconf,
  snap4g_servicetypepriorityconf_1.servicetypepriorityconf;
     
