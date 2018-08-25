--Cette fonction permet d'utiliser une variable comme nom d'élement XML, la fonction classique xmlelement() n'en est pas capable
--source: www.dbforums.com/showthread.php?1656047-Variable-name-of-XMLELEMENT
CREATE OR REPLACE FUNCTION named_node(name text, contents text) RETURNS XML
AS
$$
  SELECT XML('<' || $1 || '>' || $2 || '</' || $1 || '>');
$$ LANGUAGE 'sql';


--STEP1 : aggregation au niveau fddcell:
DROP TABLE IF EXISTS t_xml_step1_fddcell;
CREATE TABLE t_xml_step1_fddcell AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
xmlelement(
	name "FDDCell",
	xmlattributes (fddcell as "id", 'modify' as "method"),
	xmlelement(
		name "attributes",
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name, 
			xmlagg(
				xmlelement(name "value", '', param_value)
			)
		)
	)
)
 AS xml_fddcell
	
FROM public.t_fddcell_list_generic_corrections
GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
param_name

ORDER BY
rnc,
nodeb,
fddcell
;

--step2: Aggregation niveau nodeB
DROP TABLE IF EXISTS t_xml_step2_nodeb;
CREATE TABLE t_xml_step2_nodeb AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
xmlelement(
	name "NodeB",
	xmlattributes (nodeb as "id"),
	xmlagg( xml_fddcell )
) AS xml_nodeb
	
FROM public.t_xml_step1_fddcell
GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb

ORDER BY
rnc,
nodeb
;

--step 3: Aggregation niveau RNC
DROP TABLE IF EXISTS t_xml_step3_rnc;
CREATE TABLE t_xml_step3_rnc AS

SELECT 
xmlelement(
	name "RNC", 
	xmlattributes ("rnc" as "id", 'RNC' as "model", "provisionedsystemrelease" as "version", clusterid as "clusterId"),
	xmlagg( xml_nodeb )
) AS xml_rnc
	
FROM public.t_xml_step2_nodeb
GROUP BY
rnc,
provisionedsystemrelease,
clusterid

ORDER BY
rnc
;


--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xml_step4_workorder;
CREATE TABLE t_xml_step4_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('correction by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xml_step3_rnc

;


