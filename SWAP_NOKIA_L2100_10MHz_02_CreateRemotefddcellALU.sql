DROP TABLE IF EXISTS t_remotefddcell_generic_create;
CREATE TABLE t_remotefddcell_generic_create AS

SELECT 
  CASE t_swap_l2100_10mhz_action.action
	WHEN 'keep' THEN snap3g_fddcell.fddcell 
	WHEN 'future_fdd7' THEN ( left(snap3g_fddcell.fddcell, -1) || '4') 
	ELSE 'ERROR'
  END AS remotefddcell,
	
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
CASE t_swap_l2100_10mhz_action.action
	WHEN 'keep' THEN snap3g_fddcell.dlFrequencyNumber 
	WHEN 'future_fdd7' THEN '10712' 
	ELSE 'ERROR'
 END AS dlFrequencyNumber,
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
snap3g_fddcell.locationAreaCode AS locationAreaCode,
'208'::text AS mobileCountryCode,
'01'::text AS mobileNetworkCode,
'false'::text AS multiRabBadRadioSmartEdchResourceUsageActivation,
'true'::text AS multiRabSmartEdchResourceUsageActivation,
snap3g_fddcell.cellid AS neighbouringFDDCellId,
t_swap_l2100_10mhz_action.rncid_nokia AS neighbouringRNCId,
snap3g_fddcell.primaryScramblingCode AS primaryScramblingCode,
'0'::text AS reserved0,
'0'::text AS reserved1,
'0'::text AS reserved2,
'0'::text AS reserved3,
'2'::text AS routingAreaCode,
CASE t_swap_l2100_10mhz_action.action
	WHEN 'keep' THEN snap3g_fddcell.ulFrequencyNumber 
	WHEN 'future_fdd7' THEN '9762' 
	ELSE 'ERROR'
 END AS ulFrequencyNumber,
'false'::text AS useOptimizedEdchHarqRetransAtCellEdge

FROM 
  public.snap3g_fddcell INNER JOIN public.t_swap_l2100_10mhz_action
  ON 
	t_swap_l2100_10mhz_action.fddcell = snap3g_fddcell.fddcell
  INNER JOIN snap3g_rnc
  ON
	snap3g_rnc.rnc = snap3g_fddcell.rnc
WHERE
  t_swap_l2100_10mhz_action.action != 'destroy'  --on enleve les cellules detruites
  ;

--Donne la liste des remotefddcell FDD7 à créer sur les RNCs autres que le RNC en cours de swap:
DROP TABLE IF EXISTS t_swap_l2100_remotefddcell_needed;
CREATE TABLE t_swap_l2100_remotefddcell_needed AS

SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease, 
  left(snap3g_remotefddcell.remotefddcell , -1) || '4' AS remotefddcell,
  t_swap_l2100_10mhz_action.freq_config
FROM 
  public.t_swap_l2100_10mhz_action INNER JOIN public.snap3g_remotefddcell
  ON
	t_swap_l2100_10mhz_action.fddcell = snap3g_remotefddcell.remotefddcell
  INNER JOIN public.snap3g_rnc
  ON
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE 
  t_swap_l2100_10mhz_action.dlfrequencynumber = '10787' AND --On va ajouter des remotefdd7 là ou les fdd10 sont présentes
  t_swap_l2100_10mhz_action.freq_config != '10712-10787-10812-10836' --si on etait quadrifreq les remote utiles existent déja
;

--Ajoute la liste des remotefddcell FDD7 à créer sur les RNCs voisins:
INSERT INTO t_remotefddcell_generic_create

SELECT 
  t_swap_l2100_remotefddcell_needed.remotefddcell, 
  t_swap_l2100_remotefddcell_needed.rnc, 
  t_swap_l2100_remotefddcell_needed.clusterid, 
  t_swap_l2100_remotefddcell_needed.provisionedsystemrelease, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemargincs, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemargincsps, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemarginps, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemarginsmallcellhocs, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemarginsmallcellhocsps, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemarginsmallcellhops, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemarginsmallcellnonhocs, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemarginsmallcellnonhocsps, 
  t_remotefddcell_generic_create.cpichecnothresholdinterferencemarginsmallcellnonhops, 
  t_remotefddcell_generic_create.dlfrequencynumber, 
  t_remotefddcell_generic_create.edchharqcombiningcapability, 
  t_remotefddcell_generic_create.edchminsfcapability, 
  t_remotefddcell_generic_create.enhancedpsrabbadradiosmartedchresourceusageactivation, 
  t_remotefddcell_generic_create.fallbackpolicyuponcacfailureondrnc, 
  t_remotefddcell_generic_create.iscacenhancementonpsrabmodificationallowed, 
  t_remotefddcell_generic_create.iscpcdtxdrxmodeallowed, 
  t_remotefddcell_generic_create.iscsspeechoverhspaallowed, 
  t_remotefddcell_generic_create.iscsroperation, 
  t_remotefddcell_generic_create.isdl64qamallowed, 
  t_remotefddcell_generic_create.isedchallowed, 
  t_remotefddcell_generic_create.isedchtti2msallowed, 
  t_remotefddcell_generic_create.isfastl1synchronizationallowed, 
  t_remotefddcell_generic_create.ishsservingcellchangeimprovallowed, 
  t_remotefddcell_generic_create.ishsdpaallowed, 
  t_remotefddcell_generic_create.isinterferencehofailcalldropallowed, 
  t_remotefddcell_generic_create.ismacehscapable, 
  t_remotefddcell_generic_create.ismaciisallowed, 
  t_remotefddcell_generic_create.isqchatallowed, 
  t_remotefddcell_generic_create.issmallcell, 
  t_remotefddcell_generic_create.issrboverhspaenabled, 
  t_remotefddcell_generic_create.isvoipoverhspaallowed, 
  t_remotefddcell_generic_create.isvtcallblockatmobilityoncellallowed, 
  t_remotefddcell_generic_create.isvtcallblockoncellallowed, 
  t_remotefddcell_generic_create.localcellid, 
  t_remotefddcell_generic_create.locationareacode, 
  t_remotefddcell_generic_create.mobilecountrycode, 
  t_remotefddcell_generic_create.mobilenetworkcode, 
  t_remotefddcell_generic_create.multirabbadradiosmartedchresourceusageactivation, 
  t_remotefddcell_generic_create.multirabsmartedchresourceusageactivation, 
  t_remotefddcell_generic_create.neighbouringfddcellid, 
  t_remotefddcell_generic_create.neighbouringrncid, 
  t_remotefddcell_generic_create.primaryscramblingcode, 
  t_remotefddcell_generic_create.reserved0, 
  t_remotefddcell_generic_create.reserved1, 
  t_remotefddcell_generic_create.reserved2, 
  t_remotefddcell_generic_create.reserved3, 
  t_remotefddcell_generic_create.routingareacode, 
  t_remotefddcell_generic_create.ulfrequencynumber, 
  t_remotefddcell_generic_create.useoptimizededchharqretransatcelledge
FROM 
  public.t_swap_l2100_remotefddcell_needed, 
  public.t_remotefddcell_generic_create
WHERE 
  t_swap_l2100_remotefddcell_needed.remotefddcell = t_remotefddcell_generic_create.remotefddcell;