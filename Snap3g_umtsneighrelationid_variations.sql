SELECT 
  string_agg(snap3g_umtsneighbouringrelation.rnc,',' ORDER BY snap3g_umtsneighbouringrelation.rnc) AS rnc_list,
  count(snap3g_umtsneighbouringrelation.rnc) AS rnc_count,
  snap3g_umtsneighbouringrelation.umtsneighbouringrelation, 
  snap3g_umtsneighbouringrelation.maxallowedultxpower, 
  snap3g_umtsneighbouringrelation.neighbouringcelloffset, 
  snap3g_umtsneighbouringrelation.qoffset1sn, 
  snap3g_umtsneighbouringrelation.qoffset2sn, 
  snap3g_umtsneighbouringrelation.qoffsetmbms, 
  snap3g_umtsneighbouringrelation.qqualmin, 
  snap3g_umtsneighbouringrelation.qrxlevmin,
  COUNT(snap3g_umtsneighbouringrelation.umtsneighbouringrelation) AS NB
FROM 
  public.snap3g_umtsneighbouringrelation
GROUP BY
  snap3g_umtsneighbouringrelation.umtsneighbouringrelation, 
  snap3g_umtsneighbouringrelation.maxallowedultxpower, 
  snap3g_umtsneighbouringrelation.neighbouringcelloffset, 
  snap3g_umtsneighbouringrelation.qoffset1sn, 
  snap3g_umtsneighbouringrelation.qoffset2sn, 
  snap3g_umtsneighbouringrelation.qoffsetmbms, 
  snap3g_umtsneighbouringrelation.qqualmin, 
  snap3g_umtsneighbouringrelation.qrxlevmin

ORDER BY
  snap3g_umtsneighbouringrelation.umtsneighbouringrelation ASC,
  NB DESC;
