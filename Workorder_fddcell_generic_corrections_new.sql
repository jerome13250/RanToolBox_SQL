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
  SELECT TEXT(split_part(split_part($1, '_', $2),'[', 1) );
$$ LANGUAGE 'sql';

--Cree une fonction renvoyant l'id "[xxx]" en fonction du niveau souhaité dans le ran_path
CREATE OR REPLACE FUNCTION id_level(ran_path text, level int) RETURNS TEXT 
AS
$$
  SELECT TEXT(replace(split_part(split_part($1, '_', $2),'[', 2) ,']',''));
$$ LANGUAGE 'sql';


--Aggregation des parametres simples sous fddcell:
DROP TABLE IF EXISTS t_xmlfddcell_fddcell;
CREATE TABLE t_xmlfddcell_fddcell AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
1::numeric AS fddcell_modify, --introduit un flag modification pour savoir si cet objet est modifié
xmlelement(
	name "attributes",
	xmlagg(
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name,
			param_value
		)
	)
)
 AS xml_fddcell
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et btscell
WHERE
ran_path = 'RNC_NodeB_FDDCell' --params sous fddcell


GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell


ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell
;

--Aggregation des sous-objets simples (sans descendant) sous fddcell
INSERT INTO t_xmlfddcell_fddcell -- L'objet est simple on peut directement l'aggréger a fddcell

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
0::numeric AS fddcell_modify, --flag modification fddcell, 0 car l'objet en cours est un sous objet
named_node(
	object_level(ran_path,4), --On retrouve le nom de l'objet ordre 4 sans l'info id : RNC_NodeB_FDDCell_App[0] donne 'App'
	attribute_text('id',id_level(ran_path,4)) || attribute_text('method','modify'), --on retrouve l'id avec la fonction id_level
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
 AS xml_fddcell
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et fddcell
WHERE
ran_path IN ('RNC_NodeB_FDDCell_App[0]',
		'RNC_NodeB_FDDCell_EdchResource[0]',
		'RNC_NodeB_FDDCell_FddIntelligentMultiCarrierTrafficAllocation[0]',
		'RNC_NodeB_FDDCell_HsdpaResource[0]',
		'RNC_NodeB_FDDCell_InterFreqHhoFddCell[0]',
		'RNC_NodeB_FDDCell_LimitedPowerIncrease[0]',
		'RNC_NodeB_FDDCell_OCNSChannelsParameters[0]')


GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
fddcell,
nodeb,
ran_path

ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
fddcell,
ran_path
;


--Aggregation des parametres simples sous RNC_NodeB_FDDCell_RACH[0]
DROP TABLE IF EXISTS t_xmlfddcell_rach;
CREATE TABLE t_xmlfddcell_rach AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
0::numeric AS fddcell_modify, --introduit un flag modification pour savoir si cet objet est modifié
ran_path as rach,
1::numeric AS rach_modify, --introduit un flag modification pour savoir si cet objet est modifié
xmlelement(
	name "attributes",
	xmlagg(
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name,
			param_value
		)
	)
)
 AS xml_rach
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et fddcell
WHERE
ran_path = 'RNC_NodeB_FDDCell_RACH[0]'

GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
ran_path

ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
ran_path
;


--Aggregation des sous-objets simples (sans descendant) sous RACH:  
INSERT INTO t_xmlfddcell_rach -- L'objet est simple on peut directement l'aggréger a rach

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
0::numeric AS fddcell_modify, --flag modification fddcell, 0 car l'objet en cours est un sous objet
'RNC_NodeB_FDDCell_RACH[0]' as rach, --il faut enlever le dernier objet
0::numeric AS rach_modify, --introduit un flag modification pour savoir si cet objet est modifié
named_node(
	object_level(ran_path,5), --On retrouve le nom de l'objet ordre 5 sans l'info id : RNC_NodeB_FDDCell_RACH[0]_AccessServiceClass[0] donne 'AccessServiceClass'
	attribute_text('id',id_level(ran_path,5)) || attribute_text('method','modify'), --on retrouve l'id avec la fonction id_level
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
 AS xml_rach
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et fddcell
WHERE
ran_path LIKE 'RNC\_NodeB\_FDDCell\_RACH[0]\_AccessServiceClass%' --Tous les sous objets _AccessServiceClass sont valides car aucun n'a lui même de sous-objet

GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
fddcell,
nodeb,
ran_path

ORDER BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
ran_path
;

--Aggregation niveau Rach et insertion dans fddcell
INSERT INTO t_xmlfddcell_fddcell

SELECT
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
0::numeric AS fddcell_modify, --flag modification fddcell, 0 car l'objet en cours est un sous objet
named_node(
	'RACH', 
	attribute_text('id','0') || CASE WHEN MAX(rach_modify)=1 THEN attribute_text('method','modify') ELSE '' END,
	xmlagg( xml_rach )
) AS xml_rach_aggr
	
FROM public.t_xmlfddcell_rach
GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell,
rach

ORDER BY
rnc,
fddcell
;


--Aggregation niveau fddcell
DROP TABLE IF EXISTS t_xmlfddcell_fddcell_aggr;
CREATE TABLE t_xmlfddcell_fddcell_aggr AS

SELECT
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
named_node(
	'FDDCell', 
	attribute_text('id',fddcell) || CASE WHEN MAX(fddcell_modify)=1 THEN attribute_text('method','modify') ELSE '' END,
	xmlagg( xml_fddcell )
) AS xml_fddcell_aggr
	
FROM public.t_xmlfddcell_fddcell
GROUP BY
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
fddcell

ORDER BY
rnc,
nodeb,
fddcell
;

--Aggregation niveau nodeB
DROP TABLE IF EXISTS t_xmlfddcell_nodeb;
CREATE TABLE t_xmlfddcell_nodeb AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
xmlelement(
	name "NodeB",
	xmlattributes (nodeb as "id"),
	xmlagg( xml_fddcell_aggr )
) AS xml_nodeb
	
FROM public.t_xmlfddcell_fddcell_aggr
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
DROP TABLE IF EXISTS t_xmlfddcell_rnc;
CREATE TABLE t_xmlfddcell_rnc AS

SELECT 
xmlelement(
	name "RNC", 
	xmlattributes (rnc as "id", 'RNC' as "model", provisionedsystemrelease as "version", clusterid as "clusterId"),
	xmlagg( xml_nodeb )
) AS xml_rnc
	
FROM public.t_xmlfddcell_nodeb
GROUP BY
rnc,
provisionedsystemrelease,
clusterid

ORDER BY
rnc
;

--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmlfddcell_workorder;
CREATE TABLE t_xmlfddcell_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('correction fddcell by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlfddcell_rnc



