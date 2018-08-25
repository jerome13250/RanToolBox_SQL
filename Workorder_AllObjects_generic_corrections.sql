--Cette fonction permet d'utiliser une variable comme nom d'élement XML, la fonction classique xmlelement() n'en est pas capable
--source: www.dbforums.com/showthread.php?1656047-Variable-name-of-XMLELEMENT
CREATE OR REPLACE FUNCTION named_node(name text, contents text) RETURNS XML
AS
$$
  SELECT XML('<' || $1 || '>' || $2 || '</' || $1 || '>');
$$ LANGUAGE 'sql';

--Surcharge de la fonction precedente avec attributs:
CREATE OR REPLACE FUNCTION named_node(name text, attributes text,contents xml) RETURNS XML 
AS
$$
  SELECT XML('<' || $1 || $2 ||'>' || $3 || '</' || $1 || '>');
$$ LANGUAGE 'sql';

--Cree une fonction remplaçant xmlattribute plus simple et plus flexible
CREATE OR REPLACE FUNCTION attribute_text(name_attributes text, value_attributes text) RETURNS TEXT 
AS
$$
  SELECT TEXT(' ' || $1 || '=' || '"' || $2 || '"' ); --exemple model="RNC"
$$ LANGUAGE 'sql';


--Aggregation des parametres :
DROP TABLE IF EXISTS t_xml_allObjects_nokia;
CREATE TABLE t_xml_allobjects_nokia AS

SELECT  
  xmlconcat(
	xmlcomment(name), --sert a garder l'info cellule dans le xml pour le lire plus facilement
	xmlelement( --exemple de format: <managedObject class="WBTS" version="mcRNC16" distName="PLMN-PLMN/RNC-58/WBTS-2" id="205626">
		name "managedObject",
		xmlattributes(object_class as "class", "managedObject_distName" as "distName", 'update' as "operation"),
		xmlagg(
			xmlelement(
				name "p", --exemple de format: <p name="AdjiMCC">208</p>
				xmlattributes (param_name as "name"),
				param_value
			)
		)
	)
  ) AS xml_allobjects
FROM t_allObjects_generic_corrections

GROUP BY
"managedObject_distName",
object_class,
name

ORDER BY
name,
object_class
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



