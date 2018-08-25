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


--Aggregation des parametres simples sous neighbouringrnc:
DROP TABLE IF EXISTS t_xmlneighbouringrnc_neighbouringrnc;
CREATE TABLE t_xmlneighbouringrnc_neighbouringrnc AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
xmlelement(
	name "NeighbouringRNC",
	xmlattributes (neighbouringrnc as "id", 'modify' as "method"),
	xmlelement(
		name "attributes",
		xmlagg(
			named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
				parametre, 
				valeur
			)
		)
	)
)
 AS xml_neighbouringrnc
	
FROM public.t_neighbouringrnc_generic_corrections

GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
neighbouringrnc


ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
neighbouringrnc
;



--Aggregation niveau rnc
DROP TABLE IF EXISTS t_xmlneighbouringrnc_rnc;
CREATE TABLE t_xmlneighbouringrnc_rnc AS

SELECT 
xmlelement(
	name "RNC", 
	xmlattributes (rnc as "id", 'RNC' as "model", provisionedsystemrelease as "version", clusterid as "clusterId"),
	xmlagg( xml_neighbouringrnc )
) AS xml_rnc
	
FROM public.t_xmlneighbouringrnc_neighbouringrnc
GROUP BY
rnc,
provisionedsystemrelease,
clusterid

ORDER BY
rnc
;

--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmlneighbouringrnc_workorder;
CREATE TABLE t_xmlneighbouringrnc_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('correction neighbouringrnc by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlneighbouringrnc_rnc



