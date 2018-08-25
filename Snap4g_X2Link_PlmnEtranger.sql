SELECT 
  * 
FROM 
  public.snap4g_x2access
WHERE
  plmnmobilecountrycode != '208' AND
  (noX2 = 'false' OR noremove = 'false')
ORDER BY
  x2access
  ;
