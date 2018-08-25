SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.nodeb,
  snap3g_btscell.btscell, 
  t_topologie3g.codenidt,
  '' AS "noeud",
  t_topologie3g.localcellid,
  t_topologie3g.sector_number, 
  t_topologie3g.fddcell,
  t_topologie3g.dlfrequencynumber,
  bdref_t_topologie."Classe",
  t_topologie3g.administrativestate,
  snap3g_antennaaccess.antennaaccess, 
  snap3g_antennaaccess.tmaaccesstype, 
  snap3g_antennaaccess.externalattenuationtype, 
  t_vam_hardware_list."TRDU60",
  t_vam_hardware_list."TWINRRH",
  t_vam_hardware_list."ECEM-U",
  t_vam_hardware_list."ECEM",
  t_topologie3g.pertes_p2_2100,
  snap3g_fddcell.pcpichpower, 
  snap3g_fddcell.maxtxpower,  
  snap3g_antennaaccess.externalattenuationmaindl 

FROM 
  public.t_topologie3g, 
  public.snap3g_antennaaccess, 
  public.snap3g_btscell, 
  public.snap3g_fddcell,
  public.opteo_module_detection_3g_vam,
  t_vam_hardware_list,
  bdref_t_topologie
WHERE 
  t_topologie3g.fddcell = snap3g_btscell.associatedfddcell AND
  t_topologie3g.fddcell = snap3g_fddcell.fddcell AND
  t_topologie3g.localcellid = bdref_t_topologie."LCID" AND
  snap3g_btscell.btsequipment = snap3g_antennaaccess.btsequipment AND
  snap3g_btscell.btsequipment = t_vam_hardware_list.btsequipment AND
  snap3g_btscell.antennaaccesslist = snap3g_antennaaccess.antennaaccess AND
  t_topologie3g.nodeb = "NODEB" AND
  t_topologie3g.dlfrequencynumber IN ('10787','10812','10836')
ORDER BY
  t_topologie3g.fddcell ASC;
