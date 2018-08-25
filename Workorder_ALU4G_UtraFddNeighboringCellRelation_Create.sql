--Aggregation au niveau UtraFddNeighboringFreqConf: Il existe une version 0 et une 4 !
DROP TABLE IF EXISTS t_xml_alu4gUtraFddNeighboringCellRelation_create_UtraFddNFrC;
CREATE TABLE t_xml_alu4gUtraFddNeighboringCellRelation_create_UtraFddNFrC AS --Obligé de raccourcir le nom de la table

SELECT 
ENBEquipment,
version,
LteCell,
xmlelement( 
	name "UtraFddNeighboringFreqConf",		--<UtraFddNeighboringFreqConf id="0">
	xmlattributes (UtraFddNeighboringFreqConf as "id"),
	xmlagg(
		xmlelement(
			name "UtraFddNeighboringCellRelation", --<UtraFddNeighboringCellRelation id="ABADIE_BIS_U11" method="create">
			xmlattributes (UtraFddNeighboringCellRelation as "id", 'create' as "method"),
			xmlelement(
				name "attributes",
				xmlforest( 
					cId AS "cId",
					lac AS "lac",
					physCellIdUTRA AS "physCellIdUTRA",
					rac AS "rac",
					'UtranAccessGroup/0 RncAccess/' || rncAccessId AS "rncAccessId",
					voiceOverIpCapability AS "voiceOverIpCapability",
					isCellIncludedForRedirectionAssistance AS "isCellIncludedForRedirectionAssistance",
					noHoOrRedirection AS "noHoOrRedirection",
					noRemove AS "noRemove",
					isCollocated AS "isCollocated"
						
				)
			)
		)
	)
)
AS xml_UtraFddNeighboringFreqConf
	
FROM public.t_alu4g_UtraFddNeighboringCellRelation_generic_creation
GROUP BY
ENBEquipment,
version,
LteCell,
UtraFddNeighboringFreqConf

ORDER BY
ENBEquipment,
version,
LteCell,
UtraFddNeighboringFreqConf
;

--Aggregation au niveau LteCell:
DROP TABLE IF EXISTS t_xml_alu4gUtraFddNeighboringCellRelation_create_LteCell;
CREATE TABLE t_xml_alu4gUtraFddNeighboringCellRelation_create_LteCell AS

SELECT 
ENBEquipment,
version,
xmlelement(
	name "LteCell",		--<LteCell id="MANDELIEU_GRAND_DUC_ESCOTA_E1">
	xmlattributes (LteCell as "id"),
	xmlelement(
		name "UtraNeighboring",		--<UtraNeighboring id="0">)
		xmlattributes ('0' as "id"),
		xmlagg( xml_UtraFddNeighboringFreqConf )

	)
)
 AS xml_LteCell
	
FROM public.t_xml_alu4gUtraFddNeighboringCellRelation_create_UtraFddNFrC
GROUP BY
ENBEquipment,
version,
LteCell

ORDER BY
ENBEquipment,
version,
LteCell
;


--Aggregation niveau ENBEquipment
DROP TABLE IF EXISTS t_xml_alu4gUtraFddNeighboringCellRelation_create_ENBEquipment;
CREATE TABLE t_xml_alu4gUtraFddNeighboringCellRelation_create_ENBEquipment AS

SELECT 
xmlelement(
	name "ENBEquipment",			--<ENBEquipment id="MANDELIEU_GRAND_DUC_ESCOTA" model="ENB" version="LR_16_01_L">
	xmlattributes (ENBEquipment as "id", 'ENB' as "model", version as "version"),
		xmlelement(					
			name "Enb",			--<Enb id="0">
			xmlattributes ('0' as "id"),
			xmlagg( xml_LteCell )
		)
) AS xml_ENBEquipment
	
FROM public.t_xml_alu4gUtraFddNeighboringCellRelation_create_LteCell
GROUP BY
ENBEquipment,
version

ORDER BY
ENBEquipment
;


--Aggregation finale
DROP TABLE IF EXISTS t_xml_alu4gUtraFddNeighboringCellRelation_create_workorder;
CREATE TABLE t_xml_alu4gUtraFddNeighboringCellRelation_create_workorder AS
SELECT 
xmlroot (
	xmlelement (
		name "workorders",
		xmlelement(
			name "workorder", 
			xmlattributes ('UtraFddNeighboringCellRelation creation by Postgresql' as "name", 'PostGreSql' as "originator", '' as "description"),
			xmlagg(xml_ENBEquipment)
		)
	),
	VERSION '1.0',
	STANDALONE YES
)
	
FROM public.t_xml_alu4gUtraFddNeighboringCellRelation_create_ENBEquipment  

;
  
  
  
  
