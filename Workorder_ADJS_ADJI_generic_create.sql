--Aggregation des parametres :
DROP TABLE IF EXISTS t_xml_allObjects_nokia;
CREATE TABLE t_xml_allObjects_nokia AS

SELECT  
  xmlconcat(
	xmlcomment("NOMs" || ' - ' || "NOMv"), --sert a garder l'info cellule dans le xml pour le lire plus facilement
	xmlelement( --exemple de format: <managedObject class="ADJI" distName="PLMN-PLMN/RNC-419/WBTS-12/WCEL-256951/ADJI-5" operation="create" version="mcRNC17">
		name "managedObject",
		xmlattributes("object_type" as "class", "WCEL_managedObject_distName" || '/' || "object_type" || '-' || adjs_adji_list as "distName", 'create' as "operation","managedObject_version" as "version"),
		xmlagg(
			xmlelement(
				name "p", --ne change jamais
				xmlattributes ("nom_champ_vois" as "name"),
				"str_valeur"
			)
			
			
		)
	)
  ) AS xml_allobjects
FROM t_adjs_adji_generic_create
GROUP BY
  "NOMs",
  "NOMv",
  "WCEL_managedObject_distName",
  "object_type",
  adjs_adji_list,
  "managedObject_version"

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



