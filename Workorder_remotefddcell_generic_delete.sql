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


--Aggregation des parametres simples sous remotefddcell:
DROP TABLE IF EXISTS t_xmlremotefddcell_remotefddcell_delete;
CREATE TABLE t_xmlremotefddcell_remotefddcell_delete AS

SELECT 
rnc,
provisionedsystemrelease,
replace(clusterid,'Cluster/','') AS clusterid,
xmlelement(
	name "RemoteFDDCell",
	xmlattributes (remotefddcell as "id", 'delete' as "method") --exemple:<RemoteFDDCell id="CAPO_DI_FENO_W19" method="delete">
)
 AS xml_remotefddcell
	
FROM public.t_remotefddcell_generic_delete

ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
remotefddcell
;



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
	
FROM public.t_xmlremotefddcell_remotefddcell_delete
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
			xmlattributes ('delete remotefddcell by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlremotefddcell_rnc



