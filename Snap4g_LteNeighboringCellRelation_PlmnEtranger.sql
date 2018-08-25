SELECT 
  snap4g_lteneighborplmnidentity.enbequipment, 
  snap4g_lteneighborplmnidentity.enb, 
  snap4g_lteneighborplmnidentity.ltecell, 
  snap4g_lteneighborplmnidentity.lteneighboring, 
  snap4g_lteneighborplmnidentity.lteneighboringcellrelation, 
  snap4g_lteneighborplmnidentity.lteneighboringfreqconf, 
  snap4g_lteneighborplmnidentity.lteneighborplmnidentity, 
  snap4g_lteneighborplmnidentity.isprimary, 
  snap4g_lteneighborplmnidentity.plmnmobilecountrycode, 
  snap4g_lteneighborplmnidentity.plmnmobilenetworkcode, 
  snap4g_lteneighboringcellrelation.nohoorreselection, 
  snap4g_lteneighboringcellrelation.noremove
FROM 
  public.snap4g_lteneighborplmnidentity, 
  public.snap4g_lteneighboringcellrelation
WHERE 
  snap4g_lteneighborplmnidentity.enbequipment = snap4g_lteneighboringcellrelation.enbequipment AND
  snap4g_lteneighborplmnidentity.enb = snap4g_lteneighboringcellrelation.enb AND
  snap4g_lteneighborplmnidentity.ltecell = snap4g_lteneighboringcellrelation.ltecell AND
  snap4g_lteneighborplmnidentity.lteneighboring = snap4g_lteneighboringcellrelation.lteneighboring AND
  snap4g_lteneighborplmnidentity.lteneighboringfreqconf = snap4g_lteneighboringcellrelation.lteneighboringfreqconf AND
  snap4g_lteneighborplmnidentity.lteneighboringcellrelation = snap4g_lteneighboringcellrelation.lteneighboringcellrelation AND
  snap4g_lteneighborplmnidentity.plmnmobilecountrycode NOT LIKE '208' AND 
  snap4g_lteneighborplmnidentity.plmnmobilenetworkcode NOT LIKE '01' AND 
  snap4g_lteneighboringcellrelation.nohoorreselection NOT LIKE 'true' AND 
  snap4g_lteneighboringcellrelation.noremove NOT LIKE 'true'
ORDER BY
  snap4g_lteneighboringcellrelation.enbequipment ASC;
