--Aggregation au niveau fddcell:
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_fddcell_delete;
CREATE TABLE t_xmlumtsfddneighbouringcell_fddcell_delete AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
nodeb,
xmlelement(
	name "FDDCell",
	xmlattributes (fddcell as "id"),
	xmlagg(
		xmlelement(
			name "UMTSFddNeighbouringCell",
			xmlattributes (umtsfddneighbouringcell as "id", 'delete' as "method")
		)
	)
)
 AS xml_fddcell_delete
	
FROM public.t_umtsfddneighbouringcell_generic_delete
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
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_nodeb_delete;
CREATE TABLE t_xmlumtsfddneighbouringcell_nodeb_delete AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
xmlelement(
	name "NodeB",
	xmlattributes (nodeb as "id"),
	xmlagg( xml_fddcell_delete )
) AS xml_nodeb_delete
	
FROM public.t_xmlumtsfddneighbouringcell_fddcell_delete
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
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_rnc_delete;
CREATE TABLE t_xmlumtsfddneighbouringcell_rnc_delete AS

SELECT 
xmlelement(
	name "RNC", 
	xmlattributes (rnc as "id", 'RNC' as "model", provisionedsystemrelease as "version", clusterid as "clusterId"),
	xmlagg( xml_nodeb_delete )
) AS xml_rnc_delete
	
FROM public.t_xmlumtsfddneighbouringcell_nodeb_delete
GROUP BY
rnc,
provisionedsystemrelease,
clusterid

ORDER BY
rnc
;

--Aggregation finale
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_workorder_delete;
CREATE TABLE t_xmlumtsfddneighbouringcell_workorder_delete AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('umtsFddNeighbouringCell delete by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc_delete )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlumtsfddneighbouringcell_rnc_delete
  
  
  
  
