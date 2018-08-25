SELECT 
  snap3g_imcraactionlist.rnc, 
  snap3g_imcraactionlist.imcraactionlist, 
  snap3g_imcraactionlist.userspecificinfo, 
  snap3g_imcraaction.imcraaction, 
  snap3g_imcraaction.carrierselectionlistid, 
  snap3g_imcraaction.imcracalltype, 
  snap3g_imcraaction.redirectpercentage
FROM 
  public.snap3g_imcraaction, 
  public.snap3g_imcraactionlist
WHERE 
  snap3g_imcraactionlist.rnc = snap3g_imcraaction.rnc AND
  snap3g_imcraactionlist.radioaccessservice = snap3g_imcraaction.radioaccessservice AND
  snap3g_imcraactionlist.imcra = snap3g_imcraaction.imcra AND
  snap3g_imcraactionlist.imcraactionlist = snap3g_imcraaction.imcraactionlist AND
  snap3g_imcraaction.rnc = 'MARSEJOL1'
ORDER BY
  snap3g_imcraaction.imcraactionlist ASC, 
  snap3g_imcraaction.imcraaction ASC;
