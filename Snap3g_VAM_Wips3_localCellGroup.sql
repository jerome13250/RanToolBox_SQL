SELECT 
  snap3g_btscell.btsequipment AS "BTSEquipment", 
  snap3g_localcellgroup.localcellgroup AS "LocalCellGroup",
  '0' AS "frequencyGroupId",

  --Juste pour vérification:
  snap3g_btscell.associatedfddcell AS "info_associatedfddcell",  
  snap3g_localcellgroup.frequencygroupid AS "info_frequencygroupid", 
  snap3g_btscell.dualpausage AS "info_dualpausage", 
  snap3g_btscell.paratio  AS "info_paratio"
  
FROM 
  public.opteo_module_detection_3g_vam, 
  public.snap3g_localcellgroup, 
  public.snap3g_btscell, 
  public.t_topologie3g
WHERE 
  opteo_module_detection_3g_vam."NODEB" = snap3g_localcellgroup.btsequipment AND
  snap3g_btscell.btsequipment = opteo_module_detection_3g_vam."NODEB" AND
  snap3g_btscell.localcellgroupid = snap3g_localcellgroup.localcellgroup AND
  snap3g_btscell.associatedfddcell = t_topologie3g.fddcell AND
  t_topologie3g.dlfrequencynumber IN ('10787','10812','10836')
ORDER BY
  snap3g_btscell.associatedfddcell ASC;
