SELECT 
  snap3g_radioaccessservice.rnc, 
  snap3g_radioaccessservice.isfastdormancyallowed, 
  snap3g_radioaccessservice.ueversionforscri, 
  snap3g_uetimercstconnectedmode.t323, 
  snap3g_radioaccessservice.isextendedfastdormancyallowed
FROM 
  public.snap3g_radioaccessservice, 
  public.snap3g_uetimercstconnectedmode
WHERE 
  snap3g_radioaccessservice.rnc = snap3g_uetimercstconnectedmode.rnc AND
  snap3g_radioaccessservice.radioaccessservice = snap3g_uetimercstconnectedmode.radioaccessservice
ORDER BY
  snap3g_radioaccessservice.rnc ASC;
