﻿--FlexiSql
SELECT 
--name,
--"managedObject_IUR",
string_agg(replace("managedObject_distName_parent",'PLMN-PLMN/RNC-','') || '-' || "managedObject_IUR",',') AS list,
COUNT("managedObject_IUR") AS count,
"AppAwareRANEnabled",
"CellFACHnRncRelocSupport",
"DCHSDPAOverIurEnabled",
"DSCPHighIur",
"DSCPLowIur",
"DSCPMedDCHIur",
"DelayThresholdMaxIur",
"DelayThresholdMidIur",
"DelayThresholdMinIur",
"FRLCOverIurEnabled",
"HSDPA64QAMOverIurEnabled",
"HSDPACCEnabledIur",
"HSDPAULCToDSCPIur",
"HSPAOverIur",
"HSUPACCIurEnabled",
"HSUPADLCToDSCPIur",
--"IBTSSharing", --parametre obsolete
--"IPBasedRouteIdIur",
"InterfaceMode",
"IurUPSupport",
"MaxFPDLFrameSizeIur",
"MaxIurNRTHSDSCHBitRate",
"MinUDPPortIur",
--"NRncId",
"NRncNetworkInd",
"NRncRelocationSupport",
--"NRncSignPointCode",
"NRncVersion",
"NeighbouringRNWElement",
"OverbookingSwitchIur",
"ProbabilityFactorMaxIur",
"RNSAPCongAndPreemption",
"ToAWEOffsetNRTDCHIP",
"ToAWEOffsetRTDCHIP",
"ToAWSOffsetNRTDCHIP",
"ToAWSOffsetRTDCHIP",
"iurBandwidth"FROM 
public."nokia_IUR"
GROUP BY
--"managedObject_IUR",
"AppAwareRANEnabled",
"CellFACHnRncRelocSupport",
"DCHSDPAOverIurEnabled",
"DSCPHighIur",
"DSCPLowIur",
"DSCPMedDCHIur",
"DelayThresholdMaxIur",
"DelayThresholdMidIur",
"DelayThresholdMinIur",
"FRLCOverIurEnabled",
"HSDPA64QAMOverIurEnabled",
"HSDPACCEnabledIur",
"HSDPAULCToDSCPIur",
"HSPAOverIur",
"HSUPACCIurEnabled",
"HSUPADLCToDSCPIur",
--"IBTSSharing",
--"IPBasedRouteIdIur",
"InterfaceMode",
"IurUPSupport",
"MaxFPDLFrameSizeIur",
"MaxIurNRTHSDSCHBitRate",
"MinUDPPortIur",
--"NRncId",
"NRncNetworkInd",
"NRncRelocationSupport",
--"NRncSignPointCode",
"NRncVersion",
"NeighbouringRNWElement",
"OverbookingSwitchIur",
"ProbabilityFactorMaxIur",
"RNSAPCongAndPreemption",
"ToAWEOffsetNRTDCHIP",
"ToAWEOffsetRTDCHIP",
"ToAWSOffsetNRTDCHIP",
"ToAWSOffsetRTDCHIP",
"iurBandwidth"
ORDER BY 
COUNT("managedObject_IUR") DESC;
