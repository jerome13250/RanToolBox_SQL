--Cette fonction permet d'utiliser une variable comme nom d'élement XML, la fonction classique xmlelement() n'en est pas capable
--source: www.dbforums.com/showthread.php?1656047-Variable-name-of-XMLELEMENT
CREATE OR REPLACE FUNCTION named_node(name text, contents text) RETURNS XML
AS
$$
  SELECT XML(
	'<' || $1 || '>' ||
	CASE
	WHEN $2 = 'unset' THEN '<' || $2 || '/>' --cas particulier unset chez ALU
	ELSE $2
	END
	|| '</' || $1 || '>')
$$ LANGUAGE 'sql';


--Surcharge de la fonction precedente avec attributs:
CREATE OR REPLACE FUNCTION named_node(name text, attributes text,contents xml) RETURNS XML 
AS
$$
  SELECT XML(
	'<' || $1 || $2 ||'>' ||
	CASE
	WHEN TEXT($3) = 'unset' THEN '<' || $3 || '/>' --cas particulier unset chez ALU
	ELSE TEXT($3)
	END 
	|| '</' || $1 || '>');
$$ LANGUAGE 'sql';

--Cree une fonction remplaçant xmlattribute plus simple et plus flexible
CREATE OR REPLACE FUNCTION attribute_text(name_attributes text, value_attributes text) RETURNS TEXT 
AS
$$
  SELECT TEXT(' ' || $1 || '=' || '"' || $2 || '"' ); --exemple model="RNC"
$$ LANGUAGE 'sql';


--Aggregation des parametres simples sous remotefddcell:
DROP TABLE IF EXISTS t_xmlremotefddcell_remotefddcell_create;
CREATE TABLE t_xmlremotefddcell_remotefddcell_create AS

SELECT
  rnc, 
  provisionedsystemrelease, 
  replace(clusterid,'Cluster/','') AS clusterid,
  xmlelement(    
	name "RemoteFDDCell",
	xmlattributes(remotefddcell as "id", 'create' as "method"), --exemple:<RemoteFDDCell id="CAPO_DI_FENO_W19" method="create">
	xmlelement(
		name "attributes",
		xmlconcat(
			named_node('cpichEcNoThresholdInterferenceMarginCs', cpichecnothresholdinterferencemargincs),
			named_node('cpichEcNoThresholdInterferenceMarginCsPs', cpichecnothresholdinterferencemargincsps),
			named_node('cpichEcNoThresholdInterferenceMarginPs', cpichecnothresholdinterferencemarginps),
			named_node('cpichEcNoThresholdInterferenceMarginSmallCellHoCs', cpichecnothresholdinterferencemarginsmallcellhocs),
			named_node('cpichEcNoThresholdInterferenceMarginSmallCellHoCsPs', cpichecnothresholdinterferencemarginsmallcellhocsps),
			named_node('cpichEcNoThresholdInterferenceMarginSmallCellHoPs', cpichecnothresholdinterferencemarginsmallcellhops),
			named_node('cpichEcNoThresholdInterferenceMarginSmallCellNonHoCs', cpichecnothresholdinterferencemarginsmallcellnonhocs),
			named_node('cpichEcNoThresholdInterferenceMarginSmallCellNonHoCsPs', cpichecnothresholdinterferencemarginsmallcellnonhocsps),
			named_node('cpichEcNoThresholdInterferenceMarginSmallCellNonHoPs', cpichecnothresholdinterferencemarginsmallcellnonhops),
			named_node('dlFrequencyNumber', dlfrequencynumber),
			named_node('edchHarqCombiningCapability', edchharqcombiningcapability),
			named_node('edchMinSfCapability', edchminsfcapability),
			named_node('enhancedPsRabBadRadioSmartEdchResourceUsageActivation', enhancedpsrabbadradiosmartedchresourceusageactivation),
			named_node('fallbackPolicyUponCacFailureOnDrnc', fallbackpolicyuponcacfailureondrnc),
			--named_node('hcsPrio_connectedMode', hcsprio_connectedmode),
			--named_node('hcsPrio_idleMode', hcsprio_idlemode),
			--named_node('hoConfClassId', hoconfclassid),
			named_node('isCacEnhancementOnPsRabModificationAllowed', iscacenhancementonpsrabmodificationallowed),
			named_node('isCpcDtxDrxModeAllowed', iscpcdtxdrxmodeallowed),
			named_node('isCsrOperation', iscsroperation),
			named_node('isCsSpeechOverHspaAllowed', iscsspeechoverhspaallowed),
			named_node('isDl64QamAllowed', isdl64qamallowed),
			named_node('isEdchAllowed', isedchallowed),
			named_node('isEdchTti2msAllowed', isedchtti2msallowed),
			named_node('isFastL1SynchronizationAllowed', isfastl1synchronizationallowed),
			named_node('isHsdpaAllowed', ishsdpaallowed),
			named_node('isHsServingCellChangeImprovAllowed', ishsservingcellchangeimprovallowed),
			named_node('isInterferenceHoFailCallDropAllowed', isinterferencehofailcalldropallowed),
			named_node('isMacEhsCapable', ismacehscapable),
			named_node('isMaciisAllowed', ismaciisallowed),
			named_node('isQChatAllowed', isqchatallowed),
			named_node('isSmallCell', issmallcell),
			named_node('isSrbOverHspaEnabled', issrboverhspaenabled),
			named_node('isVoipOverHspaAllowed', isvoipoverhspaallowed),
			named_node('isVtCallBlockAtMobilityOnCellAllowed', isvtcallblockatmobilityoncellallowed),
			named_node('isVtCallBlockOnCellAllowed', isvtcallblockoncellallowed),
			named_node('localCellId', localcellid),
			named_node('locationAreaCode', locationareacode),
			--named_node('maxAllowedUlTxPower_connectedMode', maxallowedultxpower_connectedmode),
			--named_node('maxAllowedUlTxPower_idleMode', maxallowedultxpower_idlemode),
			--named_node('measurementConfClassId', measurementconfclassid),
			named_node('mobileCountryCode', mobilecountrycode),
			named_node('mobileNetworkCode', mobilenetworkcode),
			named_node('multiRabBadRadioSmartEdchResourceUsageActivation', multirabbadradiosmartedchresourceusageactivation),
			named_node('multiRabSmartEdchResourceUsageActivation', multirabsmartedchresourceusageactivation),
			named_node('neighbouringFDDCellId', neighbouringfddcellid),
			named_node('neighbouringRNCId', neighbouringrncid),
			named_node('primaryScramblingCode', primaryscramblingcode),
			--named_node('qHcs_connectedMode', qhcs_connectedmode),
			--named_node('qHcs_idleMode', qhcs_idlemode),
			--named_node('qQualMin_connectedMode', qqualmin_connectedmode),
			--named_node('qQualMin_idleMode', qqualmin_idlemode),
			--named_node('qRxLevMin_connectedMode', qrxlevmin_connectedmode),
			--named_node('qRxLevMin_idleMode', qrxlevmin_idlemode),
			--named_node('rdnId', rdnid),
			named_node('reserved0', reserved0),
			named_node('reserved1', reserved1),
			named_node('reserved2', reserved2),
			named_node('reserved3', reserved3),
			named_node('routingAreaCode', routingareacode),
			named_node('ulFrequencyNumber', ulfrequencynumber),
			named_node('useOptimizedEdchHarqRetransAtCellEdge', useoptimizededchharqretransatcelledge)

		)
	)
	
)
 AS xml_remotefddcell


FROM 
  public.t_remotefddcell_generic_create
ORDER BY
  rnc,
  remotefddcell;
  
  
  



--Aggregation niveau rnc
DROP TABLE IF EXISTS t_xmlremotefddcell_rnc;
CREATE TABLE t_xmlremotefddcell_rnc AS

SELECT 
xmlelement(
	name "RNC", 
	xmlattributes (rnc as "id", 'RNC' as "model", provisionedsystemrelease as "version", clusterid as "clusterId"),
	xmlelement(
			name "UmtsNeighbouring",
			xmlattributes ('0' as "id"),
			xmlagg( xml_remotefddcell )
	)
)
AS xml_rnc
	
FROM public.t_xmlremotefddcell_remotefddcell_create
GROUP BY
rnc,
provisionedsystemrelease,
clusterid

ORDER BY
rnc
;

--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmlremotefddcell_workorder;
CREATE TABLE t_xmlremotefddcell_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('create remotefddcell by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlremotefddcell_rnc



