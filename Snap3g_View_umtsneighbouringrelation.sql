SELECT 
  * 
FROM 
  public.snap3g_umtsneighbouringrelation LEFT JOIN public.snap3g_fddneighcellselectioninfoconnectedmode 
  ON 
	snap3g_umtsneighbouringrelation.rnc = snap3g_fddneighcellselectioninfoconnectedmode.rnc AND
	snap3g_umtsneighbouringrelation.umtsneighbouringrelation = snap3g_fddneighcellselectioninfoconnectedmode.umtsneighbouringrelation
WHERE 
  snap3g_umtsneighbouringrelation.rnc = 'MARSEJOL1'
ORDER BY
  snap3g_umtsneighbouringrelation.umtsneighbouringrelation ASC;
