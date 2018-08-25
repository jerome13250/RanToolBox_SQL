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











--On cree les RemoteFDDCell manquants sur les RNCs:
INSERT INTO t_xmlumtsfddneighbouringcell_under_rnc

SELECT
  t_visuincohtopo_remotefddcell_missing.rnc AS rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid,

 xmlelement(
	name "UmtsNeighbouring", --exemple:<UmtsNeighbouring id="0">
	xmlattributes ('0' as "id"),
	xmlagg(
		xmlelement(    --exemple:<RemoteFDDCell id="CAPO_DI_FENO_W19" method="create">
			name "RemoteFDDCell",
			xmlattributes (t_topologie3g.fddcell as "id", 'create' as "method"),
			xmlelement(
				name "attributes",
				xmlforest(
					t_topologie3g.dlfrequencynumber AS "dlFrequencyNumber",
					t_topologie3g.edchactivation AS "isEdchAllowed",
					'false' AS isEdchTti2msAllowed, --Ce champ est toujours à False
					t_topologie3g.hsdpaactivation AS "isHsdpaAllowed",
					t_topologie3g.localcellid AS "localCellId",
					t_topologie3g.locationareacode AS "locationAreaCode",
					t_topologie3g.mobilecountrycode AS "mobileCountryCode",
					t_topologie3g.mobilenetworkcode AS "mobileNetworkCode",
					t_topologie3g.cellid AS "neighbouringFDDCellId",
					t_topologie3g.rncid AS "neighbouringRNCId",
					t_topologie3g.primaryscramblingcode AS "primaryScramblingCode",
					t_topologie3g.routingareacode AS "routingAreaCode",
					t_topologie3g.ulfrequencynumber AS "ulFrequencyNumber",
					t_topologie3g.multirabsmartedchresourceusageactivation AS "multiRabSmartEdchResourceUsageActivation"
				)
			)
		)
	)
)
 AS xml_remotefddcell


FROM 
  public.t_visuincohtopo_remotefddcell_missing INNER JOIN public.t_topologie3g
  ON 
	t_visuincohtopo_remotefddcell_missing.remotefddcell_missing = t_topologie3g.fddcell
  INNER JOIN public.snap3g_rnc
  ON 
	t_visuincohtopo_remotefddcell_missing.rnc = snap3g_rnc.rnc
GROUP BY
  t_visuincohtopo_remotefddcell_missing.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_rnc.clusterid

ORDER BY
  t_visuincohtopo_remotefddcell_missing.rnc;
  
  
  
  
  
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
  
  
  
  
