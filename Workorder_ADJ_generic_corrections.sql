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


--Aggregation des parametres sous WCEL/ADJL:
DROP TABLE IF EXISTS t_xml_ADJ_nokia;
CREATE TABLE t_xml_ADJ_nokia AS

SELECT  
  xmlconcat(
	xmlcomment(name_s || ' - ' || name_v), --sert a garder l'info cellule dans le xml pour le lire plus facilement
	xmlelement( --exemple de format: <managedObject class="WBTS" version="mcRNC16" distName="PLMN-PLMN/RNC-58/WBTS-2" id="205626">
		name "managedObject",
		xmlattributes(class as "class", "managedObject_distName" as "distName", 'update' as "operation"),
		xmlagg(
			xmlelement(
				name "p", --exemple de format: <p name="AdjiMCC">208</p>
				xmlattributes (parametre as "name"),
				valeur
			)
		)
	)
  ) AS xml_adj
FROM t_adj_generic_corrections

GROUP BY
"managedObject_distName",
name_s,
name_v,
class

ORDER BY
name_s,
name_v,
class
;


--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmladjnokia_workorder;
CREATE TABLE t_xmladjnokia_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "raml",
		xmlattributes ('2.0' as "version", 'raml120.xsd' as "xmlns"),
		xmlelement(
			name "cmData", 
			xmlattributes ('actual' as "type"),
			xmlagg( xml_adj )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xml_ADJ_nokia



