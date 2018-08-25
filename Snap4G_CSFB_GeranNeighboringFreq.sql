SELECT 
  snap4g_geranneighboringfreqsconf.enbequipment, 
  snap4g_geranneighboringfreqsconf.ltecell, 
  snap4g_geranneighboringfreqsconf.geranneighboringfreqsconf, 
  snap4g_geranneighboringfreqsconf.bandgeran, 
  snap4g_geranneighboringfreqsconf.geranarfcnlist, 
  snap4g_mobilityprioritytable.mobilityprioritytable, 
  snap4g_servicetypepriorityconf.servicetypepriorityconf, 
  snap4g_servicetypepriorityconf.emctapriority, 
  snap4g_servicetypepriorityconf.servicetype
FROM 
  public.snap4g_geranneighboringfreqsconf, 
  public.snap4g_mobilityprioritytable, 
  public.snap4g_servicetypepriorityconf
WHERE 
  snap4g_geranneighboringfreqsconf.enbequipment = snap4g_mobilityprioritytable.enbequipment AND
  snap4g_geranneighboringfreqsconf.ltecell = snap4g_mobilityprioritytable.ltecell AND
  snap4g_geranneighboringfreqsconf.geranneighboring = snap4g_mobilityprioritytable.geranneighboring AND
  snap4g_geranneighboringfreqsconf.geranneighboringfreqsconf = snap4g_mobilityprioritytable.geranneighboringfreqsconf AND
  snap4g_mobilityprioritytable.enbequipment = snap4g_servicetypepriorityconf.enbequipment AND
  snap4g_mobilityprioritytable.ltecell = snap4g_servicetypepriorityconf.ltecell AND
  snap4g_mobilityprioritytable.geranneighboring = snap4g_servicetypepriorityconf.geranneighboring AND
  snap4g_mobilityprioritytable.geranneighboringfreqsconf = snap4g_servicetypepriorityconf.geranneighboringfreqsconf AND
  snap4g_mobilityprioritytable.mobilityprioritytable = snap4g_servicetypepriorityconf.mobilityprioritytable;
