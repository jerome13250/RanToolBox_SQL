SELECT 
  t_topologie2g."BSCName", 
  t_topologie2g."SiteName", 
  t_topologie2g."codeOMC", 
  t_topologie2g."SiteID", 
  t_topologie2g."CellName", 
  t_topologie2g."CellInstanceIdentifier", 
  t_topologie2g."BSS_Release", 
  t_topologie2g.lac, 
  t_topologie2g.ci, 
  nisc_cell."RadioLinkTimeout", 
  nisc_cell."RadioLinkTimeoutAmr", 
  nisc_cell."RADIOLINK_TIMEOUT_BS", 
  nisc_cell."RadioLinkTimeoutBsAmr", 
  nisc_cell."EN_RL_RECOV", 
  nisc_cell."N_BSTXPWR_M", 
  nisc_cell."EnRepSacch", 
  nisc_cell."EFR_ENABLED", 
  nisc_cell."EN_AMR_FR", 
  nisc_cell."EN_AMR_HR"
FROM 
  public.t_topologie2g, 
  public.nisc_cell, 
  public.nisc_hocontrol
WHERE 
  t_topologie2g."CellInstanceIdentifier" = nisc_cell."CellInstanceIdentifier" AND
  nisc_cell."CellInstanceIdentifier" = nisc_hocontrol."HoControlInstanceIdentifier"
ORDER BY
  t_topologie2g."CellName" ASC;
