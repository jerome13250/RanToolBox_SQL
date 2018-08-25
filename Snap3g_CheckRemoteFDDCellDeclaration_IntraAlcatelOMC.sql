SELECT 
  snap3g_remotefddcell.rnc AS rnc_declaration, 
  snap3g_remotefddcell.remotefddcell AS remotefddcell,
  snap3g_remotefddcell.neighbouringrncid  AS remote_neighbouringrncid, 
  snap3g_remotefddcell.dlfrequencynumber AS remote_dlfrequencynumber, 
  snap3g_remotefddcell.localcellid  AS remote_localcellid, 
  snap3g_remotefddcell.primaryscramblingcode AS remote_primaryscramblingcode,
  snap3g_remotefddcell.locationareacode AS remote_locationareacode, 
  snap3g_remotefddcell.neighbouringfddcellid AS remote_neighbouringfddcellid,
  snap3g_fddcell.rnc, 
  snap3g_fddcell.fddcell,
  snap3g_rnc.rncid, 
  snap3g_fddcell.dlfrequencynumber,
  snap3g_fddcell.localcellid, 
  snap3g_fddcell.primaryscramblingcode,
  snap3g_fddcell.locationareacode,
  snap3g_fddcell.cellid  
FROM 
  public.snap3g_remotefddcell INNER JOIN public.snap3g_fddcell
  ON snap3g_remotefddcell.remotefddcell = snap3g_fddcell.fddcell
  INNER JOIN public.snap3g_rnc
  ON snap3g_fddcell.rnc = snap3g_rnc.rnc
WHERE 
  snap3g_fddcell.dlfrequencynumber != snap3g_remotefddcell.dlfrequencynumber OR 
  snap3g_fddcell.localcellid != snap3g_remotefddcell.localcellid OR 
  snap3g_fddcell.locationareacode != snap3g_remotefddcell.locationareacode OR 
  snap3g_remotefddcell.neighbouringrncid != snap3g_rnc.rncid OR 
  snap3g_fddcell.primaryscramblingcode != snap3g_remotefddcell.primaryscramblingcode OR 
  snap3g_fddcell.cellid != snap3g_remotefddcell.neighbouringfddcellid
ORDER BY
  remotefddcell;
