

SELECT DISTINCT
  snap3g_btsequipment.btsequipment, 
  snap3g_btsequipment.aliasname, 
  snap3g_btsequipment.isvamallowed, 
  snap3g_hsxparesource.hsxparesource, 
  snap3g_hsxparesource.modempreference, 
  snap3g_btscell.btscell, 
  snap3g_btscell.associatedfddcell,
  bdref_t_topologie."Classe", 
  snap3g_btscell.dualpausage, 
  snap3g_btscell.paratio,
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.tcell, 
  snap3g_fddcell.rnc, 
  snap3g_vamparameters.vamparameters, 
  snap3g_vamparameters.vamamplitudecoeff, 
  snap3g_vamparameters.vamphasecoeff,
  snap3g_btscell.localcellgroupid,
  snap3g_localcellgroup.rfcarrierid,
  snap3g_localcellgroup.frequencygroupid,
  snap3g_rfcarrier.hspahardwareallocation
FROM 
  public.snap3g_btscell INNER JOIN public.snap3g_btsequipment
  ON
	snap3g_btsequipment.btsequipment = snap3g_btscell.btsequipment
  INNER JOIN public.snap3g_hsdpaconf
  ON
	snap3g_btscell.btscell = snap3g_hsdpaconf.btscell AND
  	snap3g_btscell.btsequipment = snap3g_hsdpaconf.btsequipment
  INNER JOIN public.snap3g_hsxparesource
  ON
	snap3g_hsdpaconf.hsxparesourceid = snap3g_hsxparesource.hsxparesource AND
  	snap3g_hsdpaconf.btsequipment = snap3g_hsxparesource.btsequipment
  INNER JOIN public.snap3g_localcellgroup
  ON
	snap3g_btscell.localcellgroupid = snap3g_localcellgroup.localcellgroup AND
	snap3g_btscell.btsequipment = snap3g_localcellgroup.btsequipment
  INNER JOIN public.snap3g_rfcarrier
  ON
	snap3g_localcellgroup.rfcarrierid = snap3g_rfcarrier.rfcarrier AND
	snap3g_localcellgroup.btsequipment = snap3g_rfcarrier.btsequipment
  INNER JOIN public.snap3g_fddcell
  ON
	snap3g_btscell.associatedfddcell = snap3g_fddcell.fddcell
  INNER JOIN public.bdref_t_topologie
  ON 
	snap3g_fddcell.localcellid = bdref_t_topologie."LCID"
  LEFT JOIN public.snap3g_vamparameters
  ON 
	snap3g_btscell.btsequipment = snap3g_vamparameters.btsequipment AND
	snap3g_btscell.btscell = snap3g_vamparameters.btscell

WHERE
  bdref_t_topologie."Classe" LIKE 'STSR3%' AND
  --snap3g_btsequipment.btsequipment LIKE 'ST_ETN_CASINO' AND
  (
	snap3g_btsequipment.isvamallowed != 'true' OR
	snap3g_hsxparesource.modempreference != 'eCEM' OR
	snap3g_btscell.dualpausage != 'vam' OR
	snap3g_btscell.paratio NOT IN ('25','37') OR
	snap3g_vamparameters.vamamplitudecoeff != '1.000000000-1.000000000-1.000000000-1.000000000' OR
	snap3g_vamparameters.vamphasecoeff != '0-0-0-0' OR
	snap3g_localcellgroup.frequencygroupid != '0' OR
	snap3g_rfcarrier.hspahardwareallocation != 'icemNever'
  )


ORDER BY
  snap3g_btscell.associatedfddcell ASC;