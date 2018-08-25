SELECT 
  snap3g_radioaccessservice.rnc, 
  snap3g_radioaccessservice.ishsdpaallowed, 
  snap3g_radioaccessservice.isdl64qamonrncallowed, 
  snap3g_fddcell.nodeb, 
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.hsdpaactivation,
  snap3g_btsequipment.btsequipment, 
  snap3g_btsequipment.isicemallowed,
  snap3g_btscell.btscell,
  snap3g_class0cemparams.hsdparesourceactivation AS class0cemparams_hsdparesourceactivation, 
  snap3g_class3cemparams.hsdparesourceactivation AS class3cemparams_hsdparesourceactivation 
FROM 
  public.snap3g_radioaccessservice INNER JOIN public.snap3g_fddcell
  ON
	snap3g_radioaccessservice.rnc = snap3g_fddcell.rnc
  INNER JOIN public.snap3g_btscell
  ON
	snap3g_fddcell.fddcell = snap3g_btscell.associatedfddcell
  INNER JOIN public.snap3g_btsequipment
  ON
	snap3g_btscell.btsequipment = snap3g_btsequipment.btsequipment
  INNER JOIN public.snap3g_class0cemparams
  ON
	snap3g_btscell.btsequipment = snap3g_class0cemparams.btsequipment AND
	snap3g_btscell.btscell = snap3g_class0cemparams.btscell
  INNER JOIN public.snap3g_class3cemparams
  ON 
	snap3g_btscell.btsequipment = snap3g_class3cemparams.btsequipment AND
	snap3g_btscell.btscell = snap3g_class3cemparams.btscell
WHERE 
  snap3g_radioaccessservice.ishsdpaallowed = 'false' OR 
  snap3g_radioaccessservice.isdl64qamonrncallowed  = 'false' OR
  snap3g_fddcell.hsdpaactivation  = 'false' OR
  snap3g_class0cemparams.hsdparesourceactivation = 'false' OR
  snap3g_class3cemparams.hsdparesourceactivation = 'false'
ORDER BY
  snap3g_fddcell.fddcell
  ;
