--Aggregation des parametres :
DROP TABLE IF EXISTS t_xml_allObjects_nokia;
CREATE TABLE t_xml_allObjects_nokia AS

SELECT  
  xmlconcat(
	xmlcomment("NOMs" || ' - ' || "NOMv"), --sert a garder l'info cellule dans le xml pour le lire plus facilement
	xmlelement( --exemple de format: <managedObject class="WBTS" version="mcRNC16" distName="PLMN-PLMN/RNC-58/WBTS-2" id="205626">
		name "managedObject",
		xmlattributes('ADJG' as "class", "managedObject_distName" as "distName", 'delete' as "operation","managedObject_version" as "version")
	)
  ) AS xml_allobjects
FROM t_adjg_generic_delete

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



