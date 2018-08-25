--Aggregation au niveau fddcell:
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_fddcell;
CREATE TABLE t_xmlumtsfddneighbouringcell_fddcell AS

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
			xmlattributes ("umtsFddNeighbouringCell" as "id", 'create' as "method"),
			xmlelement(
				name "attributes",
				xmlforest( 
					"mbmsNeighbouringWeight" AS "mbmsNeighbouringWeight",
					"minimumCpichEcNoValueForHoOffset" AS "minimumCpichEcNoValueForHoOffset",
					"minimumCpichRscpValueForHoOffset" AS "minimumCpichRscpValueForHoOffset",
					"sib11OrDchUsage" AS "sib11OrDchUsage",
					'UmtsNeighbouring/0 UmtsNeighbouringRelation/' || "umtsNeighRelationId" AS "umtsNeighRelationId",
					"neighbourCellPrio" AS "neighbourCellPrio"
				)
			)
		)
	)
)
 AS xml_fddcell
	
FROM public.t_umtsfddneighbouringcell_generic_creation_step3_final
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
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_under_rnc;
CREATE TABLE t_xmlumtsfddneighbouringcell_under_rnc AS

SELECT 
rnc,
provisionedsystemrelease,
clusterid,
xmlelement(
	name "NodeB",
	xmlattributes (nodeb as "id"),
	xmlagg( xml_fddcell )
) AS xml_under_rnc
	
FROM public.t_xmlumtsfddneighbouringcell_fddcell
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
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_rnc;
CREATE TABLE t_xmlumtsfddneighbouringcell_rnc AS

SELECT 
xmlelement(
	name "RNC", 
	xmlattributes (rnc as "id", 'RNC' as "model", provisionedsystemrelease as "version", clusterid as "clusterId"),
	xmlagg( xml_under_rnc )
) AS xml_rnc
	
FROM public.t_xmlumtsfddneighbouringcell_under_rnc
GROUP BY
rnc,
provisionedsystemrelease,
clusterid

ORDER BY
rnc
;

--Aggregation finale
DROP TABLE IF EXISTS t_xmlumtsfddneighbouringcell_workorder;
CREATE TABLE t_xmlumtsfddneighbouringcell_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('umtsFddNeighbouringCell creation by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg( xml_rnc )
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xmlumtsfddneighbouringcell_rnc  
  
  
  
  
