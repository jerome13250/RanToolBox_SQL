SELECT
  snap3g_capacity.btsequipment,
  snap3g_btsequipment.associatednodeb,
  MAX(codenidt), --Si des valeurs sont nulles, prend la valeur NIDT remplie => evite les doublons
  snap3g_capacity.r99numbercecapacitylicensing,
  snap3g_capacity.hsdpanumberusercapacitylicensing, 
  snap3g_capacity.edchnumberusercapacitylicensing,
  cemboard_number,
  hsxparesource_number,
  t_topologie3g.cemboard_number*256 AS r99numbercecapacitylicensing_max,
  t_topologie3g.hsxparesource_number*128 AS hsdpanumberusercapacitylicensing_max,
  t_topologie3g.hsxparesource_number*128 AS hedchnumberusercapacitylicensing_max
FROM 
  public.snap3g_capacity INNER JOIN public.snap3g_btsequipment
  ON
	snap3g_capacity.btsequipment = snap3g_btsequipment.btsequipment
  INNER JOIN t_topologie3g
  ON
	snap3g_btsequipment.associatednodeb = t_topologie3g.nodeb
GROUP BY
  snap3g_capacity.btsequipment,
  snap3g_btsequipment.associatednodeb,
  snap3g_capacity.r99numbercecapacitylicensing,
  snap3g_capacity.hsdpanumberusercapacitylicensing, 
  snap3g_capacity.edchnumberusercapacitylicensing,
  cemboard_number,
  hsxparesource_number

ORDER BY
  snap3g_btsequipment.associatednodeb;
