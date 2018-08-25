DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_creation_step3_final;
CREATE TABLE t_umtsfddneighbouringcell_generic_creation_step3_final AS

SELECT 
  snap3g_umtsfddneighbouringcell.rnc, 
  snap3g_umtsfddneighbouringcell.nodeb,
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid,
  snap3g_rnc.provisionedsystemrelease,
  snap3g_umtsfddneighbouringcell.fddcell, 
  --snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell, --ancien nom ALU
  tmp_remotefddcell_namenotlikenokia.name AS "umtsFddNeighbouringCell", --nom Nokia
  snap3g_umtsfddneighbouringcell.mbmsneighbouringweight AS "mbmsNeighbouringWeight", 
  snap3g_umtsfddneighbouringcell.minimumcpichecnovalueforhooffset AS "minimumCpichEcNoValueForHoOffset", 
  snap3g_umtsfddneighbouringcell.minimumcpichrscpvalueforhooffset AS "minimumCpichRscpValueForHoOffset", 
  snap3g_umtsfddneighbouringcell.neighbourcellprio AS "neighbourCellPrio", 
  --snap3g_umtsfddneighbouringcell.rdnid, 
  --snap3g_umtsfddneighbouringcell.umtsneighcellid, 
  snap3g_umtsfddneighbouringcell.umtsneighrelationid AS "umtsNeighRelationId",
  snap3g_umtsfddneighbouringcell.sib11ordchusage AS "sib11OrDchUsage"
  
FROM 
  public.tmp_remotefddcell_namenotlikenokia, 
  public.snap3g_umtsfddneighbouringcell,
  public.snap3g_rnc
WHERE 
  tmp_remotefddcell_namenotlikenokia.rnc = snap3g_umtsfddneighbouringcell.rnc AND
  tmp_remotefddcell_namenotlikenokia.remotefddcell = snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell AND
  snap3g_umtsfddneighbouringcell.rnc = snap3g_rnc.rnc
ORDER BY
  rnc,
  fddcell,
  tmp_remotefddcell_namenotlikenokia.name;
