SELECT 
  snap3g_remotefddcell.rnc, 
  COUNT(snap3g_remotefddcell.rnc) AS NB,
  snap3g_remotefddcell.mobilenetworkcode, 
  snap3g_remotefddcell.mobilecountrycode
FROM 
  public.snap3g_remotefddcell
GROUP BY
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.mobilenetworkcode, 
  snap3g_remotefddcell.mobilecountrycode
ORDER BY
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.mobilenetworkcode, 
  snap3g_remotefddcell.mobilecountrycode;
