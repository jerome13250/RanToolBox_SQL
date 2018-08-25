DROP TABLE IF EXISTS t_remotefddcell_generic_create;
CREATE TABLE t_remotefddcell_generic_create AS

SELECT 
  snap3g_fddcell.fddcell AS remotefddcell, 
  snap3g_rnc.rnc,
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginCs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginCsPs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginPs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginSmallCellHoCs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginSmallCellHoCsPs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginSmallCellHoPs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginSmallCellNonHoCs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginSmallCellNonHoCsPs,
'0.0'::text AS cpichEcNoThresholdInterferenceMarginSmallCellNonHoPs,
snap3g_fddcell.dlFrequencyNumber AS dlFrequencyNumber,
'IRandChase'::text AS edchHarqCombiningCapability,
'2sf4'::text AS edchMinSfCapability,
'false'::text AS enhancedPsRabBadRadioSmartEdchResourceUsageActivation,
'Fallback_Imcta'::text AS fallbackPolicyUponCacFailureOnDrnc,
'false'::text AS isCacEnhancementOnPsRabModificationAllowed,
'false'::text AS isCpcDtxDrxModeAllowed,
'notAllowed'::text AS isCsSpeechOverHspaAllowed,
'false'::text AS isCsrOperation,
'false'::text AS isDl64QamAllowed,
'false'::text AS isEdchAllowed,
'false'::text AS isEdchTti2msAllowed,
'false'::text AS isFastL1SynchronizationAllowed,
'false'::text AS isHsServingCellChangeImprovAllowed,
'true'::text AS isHsdpaAllowed,
'false'::text AS isInterferenceHoFailCallDropAllowed,
'false'::text AS isMacEhsCapable,
'false'::text AS isMaciisAllowed,
'false'::text AS isQChatAllowed,
'false'::text AS isSmallCell,
'false'::text AS isSrbOverHspaEnabled,
'notAllowed'::text AS isVoipOverHspaAllowed,
'false'::text AS isVtCallBlockAtMobilityOnCellAllowed,
'false'::text AS isVtCallBlockOnCellAllowed,
snap3g_fddcell.localCellId AS localCellId,
--Allocation du localcellid qui change si on est sur du RS SFR ou BYT :
CASE 
	WHEN "nokia_WCEL"."managedObject_distName" LIKE 'PLMN-PLMN/RNC-970%' AND snap3g_fddcell.mobileNetworkCode = '10' THEN '42870'::text
	WHEN "nokia_WCEL"."managedObject_distName" LIKE 'PLMN-PLMN/RNC-970%' AND snap3g_fddcell.mobileNetworkCode = '20' THEN '20702'::text
	WHEN "nokia_WCEL"."managedObject_distName" LIKE 'PLMN-PLMN/RNC-971%' AND snap3g_fddcell.mobileNetworkCode = '10' THEN 'INCONNU_SFR'::text
	WHEN "nokia_WCEL"."managedObject_distName" LIKE 'PLMN-PLMN/RNC-971%' AND snap3g_fddcell.mobileNetworkCode = '20' THEN 'INCONNU_BYT'::text
	ELSE snap3g_fddcell.locationAreaCode 
	END AS locationAreaCode,
snap3g_fddcell.mobileCountryCode AS mobileCountryCode,
snap3g_fddcell.mobileNetworkCode,
'false'::text AS multiRabBadRadioSmartEdchResourceUsageActivation,
'true'::text AS multiRabSmartEdchResourceUsageActivation,
snap3g_fddcell.cellid AS neighbouringFDDCellId,
regexp_replace(replace("nokia_WCEL"."managedObject_distName",'PLMN-PLMN/RNC-',''), '/.*','') AS neighbouringRNCId,
snap3g_fddcell.primaryScramblingCode AS primaryScramblingCode,
'0'::text AS reserved0,
'0'::text AS reserved1,
'0'::text AS reserved2,
'0'::text AS reserved3,
CASE snap3g_fddcell.mobileNetworkCode
	WHEN '01' THEN '2'::text --si mnc=01 ORANGE alors RAC=2
	ELSE snap3g_fddcell.routingAreaCode --Cas des Ransharing restent sur leur RAC
	END AS routingAreaCode,
snap3g_fddcell.ulFrequencyNumber AS ulFrequencyNumber,
'false'::text AS useOptimizedEdchHarqRetransAtCellEdge

FROM 
  public.swap_list_lcid INNER JOIN public.snap3g_fddcell
  ON
	swap_list_lcid."LCID" = snap3g_fddcell.localcellid
  INNER JOIN public."nokia_WCEL"
  ON
	swap_list_lcid."LCID" = "nokia_WCEL"."managedObject_WCEL"
  INNER JOIN snap3g_rnc
  ON
	snap3g_fddcell.rnc = snap3g_rnc.rnc
	
