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



--Aggregation des parametres simples sous btsequipment:
DROP TABLE IF EXISTS t_xmlbtsequipment_btsequipment;
CREATE TABLE t_xmlbtsequipment_btsequipment AS

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
1::numeric AS btsequipment_modify, --introduit un flag modification pour savoir si cet objet est modifié
xmlelement(
	name "attributes",
	xmlagg(
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name,
			param_value
		)
	)
)
 AS xml_btsequipment
	
FROM public.t_nodeb_generic_corrections_new --le fichier bdref contient a la fois nodeb et btsequipment
WHERE
ran_path = 'BTSEquipment' --params sous btsequipment


GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid


ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid
;

--Aggregation des sous-objets simples (sans descendant) sous btsequipment:  
INSERT INTO t_xmlbtsequipment_btsequipment -- L'objet est simple on peut directement l'aggréger a btsequipment

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
0::numeric AS btsequipment_modify, --flag modification btsequipment, 0 car l'objet en cours est un sous objet
named_node(
	object_level(ran_path,2), --On retrouve le nom de l'objet ordre 2 sans l'info id
	attribute_text('id',id_level(ran_path,2)) || attribute_text('method','modify'), 
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
 AS xml_btsequipment
	
FROM public.t_nodeb_generic_corrections_new --le fichier bdref contient a la fois nodeb et btsequipment
WHERE
ran_path NOT LIKE 'RNC_NodeB%' AND
ran_path NOT LIKE 'BTSEquipment' AND
ran_path NOT LIKE 'BTSEquipment_RemoteRadioHead%' --Je supprime ce cas car j'ai pas le temps de tout programmer, a voir plus tard si besoin


GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
ran_path

ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid,
ran_path
;



--Aggregation niveau btsequipment
DROP TABLE IF EXISTS t_xmlbtsequipment_btsequipment_aggr;
CREATE TABLE t_xmlbtsequipment_btsequipment_aggr AS

SELECT
named_node(
	'BTSEquipment', 
	attribute_text('id',btsequipment) || attribute_text('model','BTS') || attribute_text('version',provisionedsystemrelease) || 
		attribute_text('clusterid',clusterid) || CASE WHEN MAX(btsequipment_modify)=1 THEN attribute_text('method','modify') ELSE '' END,
	xmlagg( xml_btsequipment )
) AS xml_btsequipment_aggr
	
FROM public.t_xmlbtsequipment_btsequipment
GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid

ORDER BY
btsequipment
;


--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmlbtsequipment_workorder;
CREATE TABLE t_xmlbtsequipment_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('correction btsequipment by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_btsequipment_aggr )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlbtsequipment_btsequipment_aggr



