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



--Aggregation des parametres simples sous btscell:
DROP TABLE IF EXISTS t_xmlbtscell_btscell;
CREATE TABLE t_xmlbtscell_btscell AS

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
1::numeric AS btscell_modify, --introduit un flag modification pour savoir si cet objet est modifié
xmlelement(
	name "attributes",
	xmlagg(
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name,
			param_value
		)
	)
)
 AS xml_btscell
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et btscell
WHERE
ran_path = 'BTSEquipment_BTSCell' --params sous BTSCell


GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell


ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell
;

--Aggregation des sous-objets simples (sans descendant) sous btscell: AaaFunction[0] + Class0CemParams[0] + Class3CemParams[0] 
INSERT INTO t_xmlbtscell_btscell -- L'objet est simple on peut directement l'aggréger a btscell

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
0::numeric AS btscell_modify, --flag modification btscell, 0 car l'objet en cours est un sous objet
named_node(
	object_level(ran_path,3), --On retrouve le nom de l'objet ordre 3 sans l'info id
	attribute_text('id',id_level(ran_path,3)) || attribute_text('method','modify'), 
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
 AS xml_btscell
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et btscell
WHERE
ran_path IN ('BTSEquipment_BTSCell_AaaFunction[0]','BTSEquipment_BTSCell_Class0CemParams[0]','BTSEquipment_BTSCell_Class3CemParams[0]')

GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path

ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path
;


--Aggregation des parametres simples sous BTSEquipment_BTSCell_EdchConf[0]
DROP TABLE IF EXISTS t_xmlbtscell_edchconf;
CREATE TABLE t_xmlbtscell_edchconf AS

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
0::numeric AS btscell_modify, --introduit un flag modification pour savoir si cet objet est modifié
ran_path as edchconf,
1::numeric AS edchconf_modify, --introduit un flag modification pour savoir si cet objet est modifié
xmlelement(
	name "attributes",
	xmlagg(
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name,
			param_value
		)
	)
)
 AS xml_edchconf
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et btscell
WHERE
ran_path = 'BTSEquipment_BTSCell_EdchConf[0]'

GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path

ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path
;


--Aggregation des sous-objets simples (sans descendant) sous edchconf: exemple BTSEquipment_BTSCell_EdchConf[0]_EdchServiceParameterSet[2]
INSERT INTO t_xmlbtscell_edchconf -- L'objet est simple on peut directement l'aggréger a edchconf

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
0::numeric AS btscell_modify, --flag modification btscell, 0 car l'objet en cours est un sous objet
'BTSEquipment_BTSCell_EdchConf[0]' as edchconf, --il faut enlever le dernier objet => nouvelle fonction A FAIRE
0::numeric AS edchconf_modify, --introduit un flag modification pour savoir si cet objet est modifié
named_node(
	object_level(ran_path,4), --On retrouve le nom de l'objet ordre 4 sans l'info id
	attribute_text('id',id_level(ran_path,4)) || attribute_text('method','modify'), 
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
 AS xml_edchconf
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et btscell
WHERE
ran_path LIKE 'BTSEquipment\_BTSCell\_EdchConf[0]\_%' --Tous les sous objets de EdchConf sont valides car aucun n'a lui même de sous-objet

GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path

ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path
;

--Aggregation niveau EDchConf et insertion dans BTSCell
INSERT INTO t_xmlbtscell_btscell

SELECT
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
0::numeric AS btscell_modify, --flag modification btscell, 0 car l'objet en cours est un sous objet
named_node(
	'EdchConf', 
	attribute_text('id','0') || CASE WHEN MAX(edchconf_modify)=1 THEN attribute_text('method','modify') ELSE '' END,
	xmlagg( xml_edchconf )
) AS xml_edchconf_aggr
	
FROM public.t_xmlbtscell_edchconf
GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
edchconf

ORDER BY
btsequipment,
btscell
;


--GESTION OBJETS HSDPACONF :


--Aggregation des parametres simples sous BTSEquipment_BTSCell_hsdpaConf[0]
DROP TABLE IF EXISTS t_xmlbtscell_hsdpaconf;
CREATE TABLE t_xmlbtscell_hsdpaconf AS

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
0::numeric AS btscell_modify, --introduit un flag modification pour savoir si cet objet est modifié
ran_path as hsdpaconf,
1::numeric AS hsdpaconf_modify, --introduit un flag modification pour savoir si cet objet est modifié
xmlelement(
	name "attributes",
	xmlagg(
		named_node( --fonction equivalente a xmlelement mais permet de donner une variable comme nom de balise XML
			param_name,
			param_value
		)
	)
)
 AS xml_hsdpaconf
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et btscell
WHERE
ran_path = 'BTSEquipment_BTSCell_HsdpaConf[0]'

GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path

ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path
;


--Aggregation des sous-objets simples (sans descendant) sous hsdpaconf:  
INSERT INTO t_xmlbtscell_hsdpaconf -- L'objet est simple on peut directement l'aggréger a hsdpaconf

SELECT 
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
0::numeric AS btscell_modify, --flag modification btscell, 0 car l'objet en cours est un sous objet
'BTSEquipment_BTSCell_HsdpaConf[0]' as hsdpaconf, --il faut enlever le dernier objet
0::numeric AS hsdpaconf_modify, --introduit un flag modification pour savoir si cet objet est modifié
named_node(
	object_level(ran_path,4), --On retrouve le nom de l'objet ordre 4 sans l'info id
	attribute_text('id',id_level(ran_path,4)) || attribute_text('method','modify'), 
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
 AS xml_hsdpaconf
	
FROM public.t_fddcell_generic_corrections_new --le fichier bdref contient a la fois fddcell et btscell
WHERE
ran_path LIKE 'BTSEquipment\_BTSCell\_HsdpaConf[0]\_%' --Tous les sous objets de hsdpaConf sont valides car aucun n'a lui même de sous-objet

GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path

ORDER BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
ran_path
;

--Aggregation niveau hsdpaConf et insertion dans BTSCell
INSERT INTO t_xmlbtscell_btscell

SELECT
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
0::numeric AS btscell_modify, --flag modification btscell, 0 car l'objet en cours est un sous objet
named_node(
	'HsdpaConf', 
	attribute_text('id','0') || CASE WHEN MAX(hsdpaconf_modify)=1 THEN attribute_text('method','modify') ELSE '' END,
	xmlagg( xml_hsdpaconf )
) AS xml_hsdpaconf_aggr
	
FROM public.t_xmlbtscell_hsdpaconf
GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell,
hsdpaconf

ORDER BY
btsequipment,
btscell
;




--Aggregation niveau BTSCell
DROP TABLE IF EXISTS t_xmlbtscell_btscell_aggr;
CREATE TABLE t_xmlbtscell_btscell_aggr AS

SELECT
btsequipment,
provisionedsystemrelease,
clusterid,
named_node(
	'BTSCell', 
	attribute_text('id',btscell) || CASE WHEN MAX(btscell_modify)=1 THEN attribute_text('method','modify') ELSE '' END,
	xmlagg( xml_btscell )
) AS xml_btscell_aggr
	
FROM public.t_xmlbtscell_btscell
GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid,
btscell

ORDER BY
btsequipment,
btscell
;

--Aggregation niveau BTSEquipment
DROP TABLE IF EXISTS t_xmlbtscell_btsequipment;
CREATE TABLE t_xmlbtscell_btsequipment AS

SELECT 
xmlelement(
	name "BTSEquipment", 
	xmlattributes (btsequipment as "id", 'BTS' as "model", provisionedsystemrelease as "version", clusterid as "clusterId"),
	xmlagg( xml_btscell_aggr )
) AS xml_btsequipment
	
FROM public.t_xmlbtscell_btscell_aggr
GROUP BY
btsequipment,
provisionedsystemrelease,
clusterid

ORDER BY
btsequipment
;

--step 4: Aggregation finale
DROP TABLE IF EXISTS t_xmlbtscell_workorder;
CREATE TABLE t_xmlbtscell_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('correction BTSCell by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_btsequipment )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlbtscell_btsequipment



