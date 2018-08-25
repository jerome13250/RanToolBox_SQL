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

--Cree une fonction renvoyant l'objet en fonction du niveau souhaité dans le ran_path
CREATE OR REPLACE FUNCTION object_level(ran_path text, level int) RETURNS TEXT 
AS
$$
  SELECT TEXT(split_part(split_part($1, '¤', $2),'[', 1) );
$$ LANGUAGE 'sql';

--Cree une fonction renvoyant l'id "[xxx]" en fonction du niveau souhaité dans le ran_path
CREATE OR REPLACE FUNCTION id_level(ran_path text, level int) RETURNS TEXT 
AS
$$
  SELECT TEXT(replace(split_part(split_part($1, '¤', $2),'[', 2) ,']',''));
$$ LANGUAGE 'sql';


--Aggregation des parametres simples sous nodeb:
DROP TABLE IF EXISTS t_xmlnodeb_nodeb;
CREATE TABLE t_xmlnodeb_nodeb AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
1::numeric AS nodeb_modify, --introduit un flag modification pour savoir si cet objet est modifié
xmlelement(
	name "attributes",
	xmlagg(
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name,
			param_value
		)
	)
)
 AS xml_nodeb
	
FROM public.t_nodeb_generic_corrections_new --le fichier bdref contient a la fois nodeb et btsequipment
WHERE
ran_path = 'RNC_NodeB' --params sous nodeb


GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb


ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb
;

--Aggregation des sous-objets simples (sans descendant) sous nodeb
INSERT INTO t_xmlnodeb_nodeb -- L'objet est simple on peut directement l'aggréger a nodeb

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
0::numeric AS nodeb_modify, --flag modification nodeb, 0 car l'objet en cours est un sous objet
named_node(
	object_level(ran_path,3), --On retrouve le nom de l'objet ordre 3 sans l'info id : RNC_NodeB_SctpParams[0] donne 'SctpParams'
	attribute_text('id',id_level(ran_path,3)) || attribute_text('method','modify'), --on retrouve l'id avec la fonction id_level
	xmlelement(
		name "attributes",
		xmlagg(
			named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
				param_name, 
				param_value
			)
		)
	)
)
 AS xml_nodeb
	
FROM public.t_nodeb_generic_corrections_new --le fichier bdref contient a la fois nodeb et nodeb
WHERE
ran_path LIKE 'RNC_NodeB_SctpParams[0]'

GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
nodeb,
ran_path

ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
ran_path
;

--Aggregation niveau nodeb
DROP TABLE IF EXISTS t_xmlnodeb_nodeb_aggr;
CREATE TABLE t_xmlnodeb_nodeb_aggr AS

SELECT
rnc,
provisionedsystemrelease,
clusterid,
named_node(
	'NodeB', 
	attribute_text('id',nodeb) || CASE WHEN MAX(nodeb_modify)=1 THEN attribute_text('method','modify') ELSE '' END,
	xmlagg( xml_nodeb )
) AS xml_nodeb_aggr
	
FROM public.t_xmlnodeb_nodeb
GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb

ORDER BY
rnc,
nodeb
;

--Aggregation niveau rnc
DROP TABLE IF EXISTS t_xmlnodeb_rnc;
CREATE TABLE t_xmlnodeb_rnc AS

SELECT 
xmlelement(
	name "RNC", 
	xmlattributes (rnc as "id", 'rnc' as "model", provisionedsystemrelease as "version", clusterid as "clusterId"),
	xmlagg( xml_nodeb_aggr )
) AS xml_rnc
	
FROM public.t_xmlnodeb_nodeb_aggr
GROUP BY
rnc,
provisionedsystemrelease,
clusterid

ORDER BY
rnc
;

--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmlnodeb_workorder;
CREATE TABLE t_xmlnodeb_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('correction nodeb by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlnodeb_rnc



