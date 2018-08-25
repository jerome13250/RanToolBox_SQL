SELECT 
  snap4g_radiocacenb.enbequipment, 
  snap4g_radiocacenb.enb, 
  snap4g_radiocacenb.radiocacenb, 
  snap4g_radiocacenb.maxnumberofcallperenodeb, 
  snap4g_radiocacenb.maxnbrofrrcconnectedusersperenb, 
  snap4g_radiocacenb.nbrofcontextsreservedforecandhpacalls, 
  snap4g_radiocaccell.ltecell, 
  snap4g_radiocaccell.radiocaccell, 
  snap4g_radiocaccell.maxnbrofusers, 
  snap4g_radiocaccell.maxnbrofactiveuserspercell
FROM 
  public.snap4g_radiocacenb INNER JOIN public.snap4g_radiocaccell
  ON snap4g_radiocacenb.enbequipment = snap4g_radiocaccell.enbequipment AND
  snap4g_radiocacenb.enb = snap4g_radiocaccell.enb
ORDER BY 
  snap4g_radiocaccell.ltecell ASC;
