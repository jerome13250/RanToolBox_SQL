DROP TABLE IF EXISTS t_temp_nisc_cell;
CREATE TABLE t_temp_nisc_cell AS
SELECT
  nisc_cell.*,
  replace(replace(substring(nisc_cell."RnlSupportingSector", 'bts { .*}, sectorRdn'),'bts ',''),', sectorRdn','') AS btsid,
  replace(replace(substring(nisc_cell."RnlSupportingSector", 'bsc .*, btsRdn'),'bsc ',''),', btsRdn','') AS bscid
  FROM
      public.nisc_cell;
      

DROP TABLE IF EXISTS t_topologie2g;
CREATE TABLE t_topologie2g AS
SELECT 
  replace(nisc_rnlalcatelbsc."UserLabel", '"', '') AS "BSCName",
  replace(nisc_rnlalcatelsitemanager."UserLabel", '"', '') AS "SiteName",
  nisc_rnlalcatelsitemanager."codeOMC",
  nisc_rnlalcatelsitemanager."RnlAlcatelSiteManagerInstanceIdentifier" AS "SiteID",
  replace(t_temp_nisc_cell."UserLabel", '"', '') AS "CellName", 
  t_temp_nisc_cell."CellInstanceIdentifier", 
  t_temp_nisc_cell."BSS_Release", 
  replace(replace(substring(t_temp_nisc_cell."CellGlobalIdentity", 'lac .*},'), 'lac ', ''), '},', '') AS lac,
  replace(replace(substring(t_temp_nisc_cell."CellGlobalIdentity", 'ci .*}'), 'ci ', ''), '}', '') AS ci, 
  t_temp_nisc_cell."AdministrativeState", 
  t_temp_nisc_cell."OperationalState", 
  t_temp_nisc_cell."AvailabilityStatus", 
  t_temp_nisc_cell."AlignmentStatus", 
  t_temp_nisc_cell."AlignmentStatusCause", 
  t_temp_nisc_cell."Azimuth", 
  t_temp_nisc_cell."GeographicalCoordinates", 
  t_temp_nisc_cell."BCCHFrequency",
  replace(substring(t_temp_nisc_cell."BsIdentityCode",'ncc .'),'ncc ','') AS ncc,
  replace(substring(t_temp_nisc_cell."BsIdentityCode",'bcc .'),'bcc ','') AS bcc,
  t_temp_nisc_cell."FrequencyRange", 
  t_temp_nisc_cell."HoppingType", 
  nisc_rnlfrequencyhoppingsystem."HoppingSequenceNumber", 
  nisc_rnlfrequencyhoppingsystem."MobileAllocation",
  replace(substring(replace(nisc_rnlalcatelsector."McModuleList", 'numberOfConfiguredTRE 0', ''), 'numberOfConfiguredTRE .'), 'numberOfConfiguredTRE ', '') AS numberOfConfiguredTRE, 
  replace(substring(nisc_rnlalcatelsector."McModuleList", 'ritType "......'), 'ritType "', '') AS mcmodulecode,
  length(nisc_rnlalcatelsector."McModuleList") - length(replace(nisc_rnlalcatelsector."McModuleList",'ritType','itType')) AS mcmodulenumber,

  CASE 	WHEN (length(nisc_rnlalcatelsector."McModuleList") - length(replace(nisc_rnlalcatelsector."McModuleList",'ritType','itType'))=1 AND nisc_rnlalcatelsector."McModuleList" NOT LIKE '%otherStandardRatioPa2 number:0%' AND t_temp_nisc_cell."FrequencyRange" = 'p_gsm') THEN 'SHARED'
	WHEN (length(nisc_rnlalcatelsector."McModuleList") - length(replace(nisc_rnlalcatelsector."McModuleList",'ritType','itType'))=1 AND nisc_rnlalcatelsector."McModuleList" NOT LIKE '%otherStandardRatioPa1 number:0%' AND t_temp_nisc_cell."FrequencyRange" = 'dcs1800') THEN 'SHARED'
        ELSE NULL END 
	AS Boardusage,
  
  CASE	WHEN t_temp_nisc_cell."FrequencyRange" = 'p_gsm' THEN nisc_rnlalcatelsector."PwrMaxGsmCapabilityPerSector" 
	WHEN t_temp_nisc_cell."FrequencyRange" = 'dcs1800' THEN nisc_rnlalcatelsector."PwrMaxDcsCapabilityPerSector"
	ELSE NULL END 
	AS PwrMaxCapability,
  nisc_rnlalcatelsector."McModuleList",
  nisc_rnlpowercontrol."BsTxPwrAttenuation",
  t_temp_nisc_cell."NbrSDCCH", 
  t_temp_nisc_cell."NbrSDCCHavailable", 
  t_temp_nisc_cell."NbrTCH", 
  t_temp_nisc_cell."NbrTCHavailable", --C1
  t_temp_nisc_cell."RxLevAccessMin",
  t_temp_nisc_cell."MSTxPwrMaxCCH",
  t_temp_nisc_cell."CELL_RESELECT_PARAM_IND", --C2 
  t_temp_nisc_cell."CELL_RESELECT_OFFSET",
  t_temp_nisc_cell."TEMPORARY_OFFSET", 
  t_temp_nisc_cell."PENALTY_TIME",
  t_temp_nisc_cell."CELL_BAR_QUALIFY", 
  t_temp_nisc_cell."CellBarred",
  t_temp_nisc_cell."CellReselectHysteresis", 
  t_temp_nisc_cell."HR_ENABLED", 
  t_temp_nisc_cell."EN_AMR_FR", 
  t_temp_nisc_cell."EN_AMR_HR", 
  t_temp_nisc_cell."PlmnPermitted",
  t_temp_nisc_cell."RMS_TEMPLATE",

  replace(replace(substring(nisc_rnlalcatelbsc."RMS_TEMPLATE_14", 'measstatta { .*}, vqaverage'),' measstat',''),', vqaverage','') AS RMS_TEMPLATE_14
FROM 
  public.t_temp_nisc_cell LEFT JOIN public.nisc_rnlfrequencyhoppingsystem
	ON
	t_temp_nisc_cell."CellInstanceIdentifier" = nisc_rnlfrequencyhoppingsystem."RnlFrequencyHoppingSystemInstanceIdentifier"
  LEFT JOIN nisc_rnlalcatelsector
	ON
	t_temp_nisc_cell."CellInstanceIdentifier" = nisc_rnlalcatelsector."RnlRelatedCell"
  LEFT JOIN nisc_rnlpowercontrol
	ON
	t_temp_nisc_cell."CellInstanceIdentifier" = nisc_rnlpowercontrol."RnlPowerControlInstanceIdentifier"
  LEFT JOIN nisc_rnlalcatelsitemanager
	ON
	t_temp_nisc_cell."codeOMC" = nisc_rnlalcatelsitemanager."codeOMC"
	AND t_temp_nisc_cell.btsid = nisc_rnlalcatelsitemanager."RnlAlcatelSiteManagerInstanceIdentifier"
  LEFT JOIN nisc_rnlalcatelbsc
	ON
	t_temp_nisc_cell."codeOMC" = nisc_rnlalcatelbsc."codeOMC"
	AND t_temp_nisc_cell.bscid = nisc_rnlalcatelbsc."RnlAlcatelBSCInstanceIdentifier"	
      
ORDER BY
  t_temp_nisc_cell."UserLabel" ASC;