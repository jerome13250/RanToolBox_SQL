--Aggregation des parametres :
DROP TABLE IF EXISTS t_xml_allObjects_nokia;
CREATE TABLE t_xml_allObjects_nokia AS

SELECT  
  xmlconcat(
	xmlcomment("NOM" || ' - ' || "name"), --sert a garder l'info cellule dans le xml pour le lire plus facilement
	xmlelement( --exemple de format: <managedObject class="ADJL" distName="PLMN-PLMN/RNC-419/WBTS-12/WCEL-256951/ADJL-1" operation="create" version="mcRNC17">
		name "managedObject",
		xmlattributes('ADJL' as "class", "managedObject_distName" as "distName", 'create' as "operation","managedObject_version" as "version"),
		xmlconcat(
			xmlelement(
				name "p", --ne change jamais
				xmlattributes ('AdjLEARFCN' as "name"),
				"AdjLEARFCN"
			),
			xmlelement(
				name "p", --ne change jamais
				xmlattributes ('AdjLMeasBw' as "name"),
				"AdjLMeasBw"
			),
			xmlelement(
				name "p", --ne change jamais
				xmlattributes ('AdjLSelectFreq' as "name"),
				"AdjLSelectFreq"
			),
			xmlelement(
				name "p", --ne change jamais
				xmlattributes ('HopLIdentifier' as "name"),
				"HopLIdentifier"
			),
			xmlelement(
				name "p", --ne change jamais
				xmlattributes ('name' as "name"),
				"name"
			)
		)
	)
  ) AS xml_allobjects
FROM t_adjl_generic_create
ORDER BY
"NOM",
name
;

/* Inutile avec la nouvelle fonction java: copyOutXMLmultiLines

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
	
FROM public.t_xml_allObjects_nokia;

*/

