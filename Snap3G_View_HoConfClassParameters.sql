SELECT
  string_agg(snap3g_hoconfclass.rnc,'-') AS list_rnc,
  COUNT(snap3g_hoconfclass.rnc) AS nb, 
  string_agg(snap3g_hoconfclass.userspecificinfo,'-') AS list_name, 
  snap3g_hoconfclass.hoconfclass, 
  snap3g_fulleventhoconfshomgtevent1a.ushoconf, 
  snap3g_fulleventhoconfshomgtevent1a.cpichecnoreportingrange1a, 
  snap3g_fulleventhoconfshomgtevent1a.hysteresis1a, 
  snap3g_fulleventhoconfshomgtevent1a.timetotrigger1a, 
  snap3g_fulleventhoconfshomgtevent1a.weight1a, 
  snap3g_fulleventhoconfshomgtevent1b.cpichecnoreportingrange1b, 
  snap3g_fulleventhoconfshomgtevent1b.hysteresis1b, 
  snap3g_fulleventhoconfshomgtevent1b.timetotrigger1b, 
  snap3g_fulleventhoconfshomgtevent1b.weight1b, 
  snap3g_fulleventhoconfshomgtevent1c.hysteresis1c, 
  snap3g_fulleventhoconfshomgtevent1c.timetotrigger1c,
  snap3g_fulleventhoconfshomgtevent1d.hysteresis1d,
  snap3g_fulleventhoconfshomgtevent1d.timetotrigger1d, 
  snap3g_fulleventhoconfhhomgtevent2d.cpichecnothresholdusedfreq2d, 
  snap3g_fulleventhoconfhhomgtevent2d.cpichrscpthresholdusedfreq2d, 
  snap3g_fulleventhoconfhhomgtevent2d.hysteresis2d, 
  snap3g_fulleventhoconfhhomgtevent2d.timetotrigger2d, 
  snap3g_fulleventhoconfhhomgtevent2d.weight2d, 
  snap3g_fulleventhoconfhhomgtevent2f.cpichecnothresholdusedfreq2f, 
  snap3g_fulleventhoconfhhomgtevent2f.cpichrscpthresholdusedfreq2f, 
  snap3g_fulleventhoconfhhomgtevent2f.hysteresis2f, 
  snap3g_fulleventhoconfhhomgtevent2f.timetotrigger2f, 
  snap3g_fulleventhoconfhhomgtevent2f.weight2f, 
  snap3g_fulleventhoconfhhomgtevent6a.timetotrigger6a, 
  snap3g_fulleventhoconfhhomgtevent6a.uetxpwrmaxthresholdoffset, 
  snap3g_fulleventhoconfhhomgtevent6b.timetotrigger6b, 
  snap3g_fulleventhoconfhhomgtevent6b.uetxpwrmaxthresholdoffset
FROM 
  public.snap3g_hoconfclass, 
  public.snap3g_fulleventhoconfshomgtevent1a, 
  public.snap3g_fulleventhoconfshomgtevent1b, 
  public.snap3g_fulleventhoconfshomgtevent1c,
  public.snap3g_fulleventhoconfshomgtevent1d, 
  public.snap3g_fulleventhoconfhhomgtevent2d, 
  public.snap3g_fulleventhoconfhhomgtevent2f, 
  public.snap3g_fulleventhoconfhhomgtevent6a, 
  public.snap3g_fulleventhoconfhhomgtevent6b
WHERE 
  snap3g_hoconfclass.rnc != 'BACKUP_A' AND
  snap3g_hoconfclass.rnc NOT LIKE 'RS\_%' AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = 'CsSpeech' AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfshomgtevent1a.rnc AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfshomgtevent1b.rnc AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfshomgtevent1c.rnc AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfshomgtevent1d.rnc AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfhhomgtevent2d.rnc AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfhhomgtevent2f.rnc AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfhhomgtevent6a.rnc AND
  snap3g_hoconfclass.rnc = snap3g_fulleventhoconfhhomgtevent6b.rnc AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfshomgtevent1a.dedicatedconf AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfshomgtevent1b.dedicatedconf AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfshomgtevent1c.dedicatedconf AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfshomgtevent1d.dedicatedconf AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfhhomgtevent2d.dedicatedconf AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfhhomgtevent2f.dedicatedconf AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfhhomgtevent6a.dedicatedconf AND
  snap3g_hoconfclass.dedicatedconf = snap3g_fulleventhoconfhhomgtevent6b.dedicatedconf AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfshomgtevent1a.hoconfclass AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfshomgtevent1b.hoconfclass AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfshomgtevent1c.hoconfclass AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfshomgtevent1d.hoconfclass AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfhhomgtevent2d.hoconfclass AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfhhomgtevent2f.hoconfclass AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfhhomgtevent6a.hoconfclass AND
  snap3g_hoconfclass.hoconfclass = snap3g_fulleventhoconfhhomgtevent6b.hoconfclass AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = snap3g_fulleventhoconfshomgtevent1b.ushoconf AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = snap3g_fulleventhoconfshomgtevent1c.ushoconf AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = snap3g_fulleventhoconfshomgtevent1d.ushoconf AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = snap3g_fulleventhoconfhhomgtevent2d.ushoconf AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = snap3g_fulleventhoconfhhomgtevent2f.ushoconf AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = snap3g_fulleventhoconfhhomgtevent6a.ushoconf AND
  snap3g_fulleventhoconfshomgtevent1a.ushoconf = snap3g_fulleventhoconfhhomgtevent6b.ushoconf 
  --AND snap3g_fulleventhoconfshomgtevent1a.ushoconf = 'CsSpeech'
 GROUP BY
  snap3g_hoconfclass.hoconfclass, 
  snap3g_fulleventhoconfshomgtevent1a.ushoconf, 
  snap3g_fulleventhoconfshomgtevent1a.cpichecnoreportingrange1a, 
  snap3g_fulleventhoconfshomgtevent1a.hysteresis1a, 
  snap3g_fulleventhoconfshomgtevent1a.timetotrigger1a, 
  snap3g_fulleventhoconfshomgtevent1a.weight1a, 
  snap3g_fulleventhoconfshomgtevent1b.cpichecnoreportingrange1b, 
  snap3g_fulleventhoconfshomgtevent1b.hysteresis1b, 
  snap3g_fulleventhoconfshomgtevent1b.timetotrigger1b, 
  snap3g_fulleventhoconfshomgtevent1b.weight1b, 
  snap3g_fulleventhoconfshomgtevent1c.hysteresis1c, 
  snap3g_fulleventhoconfshomgtevent1c.timetotrigger1c,
  snap3g_fulleventhoconfshomgtevent1d.hysteresis1d,
  snap3g_fulleventhoconfshomgtevent1d.timetotrigger1d, 
  snap3g_fulleventhoconfhhomgtevent2d.cpichecnothresholdusedfreq2d, 
  snap3g_fulleventhoconfhhomgtevent2d.cpichrscpthresholdusedfreq2d, 
  snap3g_fulleventhoconfhhomgtevent2d.hysteresis2d, 
  snap3g_fulleventhoconfhhomgtevent2d.timetotrigger2d, 
  snap3g_fulleventhoconfhhomgtevent2d.weight2d, 
  snap3g_fulleventhoconfhhomgtevent2f.cpichecnothresholdusedfreq2f, 
  snap3g_fulleventhoconfhhomgtevent2f.cpichrscpthresholdusedfreq2f, 
  snap3g_fulleventhoconfhhomgtevent2f.hysteresis2f, 
  snap3g_fulleventhoconfhhomgtevent2f.timetotrigger2f, 
  snap3g_fulleventhoconfhhomgtevent2f.weight2f, 
  snap3g_fulleventhoconfhhomgtevent6a.timetotrigger6a, 
  snap3g_fulleventhoconfhhomgtevent6a.uetxpwrmaxthresholdoffset, 
  snap3g_fulleventhoconfhhomgtevent6b.timetotrigger6b, 
  snap3g_fulleventhoconfhhomgtevent6b.uetxpwrmaxthresholdoffset
 ORDER BY 
   snap3g_hoconfclass.hoconfclass::int,
   snap3g_fulleventhoconfshomgtevent1a.ushoconf,
   COUNT(snap3g_hoconfclass.rnc) DESC
   ;
