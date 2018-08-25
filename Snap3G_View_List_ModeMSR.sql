SELECT 
   
  snap3g_mctrx.btsequipment, 
  snap3g_mctrx.mctrx, 
  snap3g_mctrx.antennaaccessid, 
  snap3g_mctrx.rdnid,
  snap3g_mctrx.isbtsdualtechnologysecondarycontroller, 
  snap3g_mctrx.reserved0, 
  snap3g_mctrx.reserved1, 
  snap3g_mctrx.reserved2, 
  snap3g_mctrx.reserved3, 
  snap3g_mctrx.userspecificinfo
FROM 
  public.snap3g_mctrx
where
  isbtsdualtechnologysecondarycontroller = 'true';
