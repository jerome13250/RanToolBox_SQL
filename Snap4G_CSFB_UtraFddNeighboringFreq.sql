SELECT 
  snap4g_utrafddneighboringfreqconf.enbequipment, 
  snap4g_utrafddneighboringfreqconf.ltecell, 
  snap4g_utrafddneighboringfreqconf.utrafddneighboringfreqconf, 
  snap4g_utrafddneighboringfreqconf.bandutrafdd, 
  snap4g_utrafddneighboringfreqconf.carrierfreq, 
  snap4g_mobilityprioritytable_2.mobilityprioritytable, 
  snap4g_servicetypepriorityconf_1.servicetypepriorityconf, 
  snap4g_servicetypepriorityconf_1.servicetype, 
  snap4g_servicetypepriorityconf_1.emctapriority
FROM 
  public.snap4g_utrafddneighboringfreqconf, 
  public.snap4g_mobilityprioritytable_2, 
  public.snap4g_servicetypepriorityconf_1
WHERE 
  snap4g_utrafddneighboringfreqconf.ltecell = snap4g_mobilityprioritytable_2.ltecell AND
  snap4g_utrafddneighboringfreqconf.utraneighboring = snap4g_mobilityprioritytable_2.utraneighboring AND
  snap4g_utrafddneighboringfreqconf.utrafddneighboringfreqconf = snap4g_mobilityprioritytable_2.utrafddneighboringfreqconf AND
  snap4g_mobilityprioritytable_2.ltecell = snap4g_servicetypepriorityconf_1.ltecell AND
  snap4g_mobilityprioritytable_2.utraneighboring = snap4g_servicetypepriorityconf_1.utraneighboring AND
  snap4g_mobilityprioritytable_2.utrafddneighboringfreqconf = snap4g_servicetypepriorityconf_1.utrafddneighboringfreqconf AND
  snap4g_mobilityprioritytable_2.mobilityprioritytable = snap4g_servicetypepriorityconf_1.mobilityprioritytable
ORDER BY
  snap4g_utrafddneighboringfreqconf.ltecell ASC, 
  snap4g_utrafddneighboringfreqconf.utrafddneighboringfreqconf ASC, 
  snap4g_servicetypepriorityconf_1.servicetypepriorityconf ASC;
