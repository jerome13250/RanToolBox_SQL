--Aggregation des parametres :
DROP TABLE IF EXISTS t_xml_allObjects_nokia;
CREATE TABLE t_xml_allObjects_nokia AS

SELECT  
  xmlconcat(
	xmlcomment("NOMs" || ' - ' || "NOMv"), --sert a garder l'info cellule dans le xml pour le lire plus facilement
	xmlelement( --exemple de format: <managedObject class="WBTS" version="mcRNC16" distName="PLMN-PLMN/RNC-58/WBTS-2" id="205626">
		name "managedObject",
		xmlattributes('ADJG' as "class", "managedObject_distName" || '/ADJG-' || adjgid as "distName", 'create' as "operation","managedObject_version" as "version"),
		xmlconcat(
			xmlelement(name "p", xmlattributes ('AdjgBCC' as "name"), "bcc"),
			xmlelement(name "p", xmlattributes ('AdjgBCCH' as "name"), "bcch"),
			xmlelement(name "p", xmlattributes ('AdjgCI' as "name"), "CIv"),
			xmlelement(name "p", xmlattributes ('AdjgLAC' as "name"), "LACv"),
			xmlelement(name "p", xmlattributes ('AdjgMCC' as "name"), "mcc"),
			xmlelement(name "p", xmlattributes ('AdjgMNC' as "name"), "mnc"),
			xmlelement(name "p", xmlattributes ('AdjgNCC' as "name"), "ncc"),
			xmlelement(name "p", xmlattributes ('AdjgSIB' as "name"), "AdjgSIB"),
			xmlelement(name "p", xmlattributes ('AdjgBandIndicator' as "name"), '0'),
			xmlelement(name "p", xmlattributes ('AdjgTxPwrMaxRACH' as "name"), 
				CASE 
					WHEN bcch::int > 100 THEN '30'  --si 1800 alors 30dBm
					ELSE '33' END
			),
			xmlelement(name "p", xmlattributes ('AdjgTxPwrMaxTCH' as "name"), 
				CASE 
					WHEN bcch::int > 100 THEN '30'  --si 1800 alors 30dBm
					ELSE '33' END
			),
			xmlelement(name "p", xmlattributes ('NrtHopgIdentifier' as "name"), 
				CASE 
					WHEN bcch::int > 100 THEN '13'  --si 1800 alors 30dBm
					ELSE '3' END
			),
			xmlelement(name "p", xmlattributes ('RtHopgIdentifier' as "name"), 
				CASE 
					WHEN bcch::int > 100 THEN '13'  --si 1800 alors 30dBm
					ELSE '3' END
			)
		)
	)
  ) AS xml_allobjects
FROM t_adjg_generic_create

ORDER BY
"NOMs",
"NOMv"
;

--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmlallobjectsnokia_workorder;
CREATE TABLE t_xmlallobjectsnokia_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "raml",
		xmlattributes ('2.0' as "version", 'raml120.xsd' as "xmlns"),
		xmlelement(
			name "cmData", 
			xmlattributes ('actual' as "type"),
			xmlagg( xml_allobjects )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xml_allObjects_nokia



