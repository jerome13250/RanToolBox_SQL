DROP TABLE IF EXISTS t_topologie4g_temp;
CREATE TABLE t_topologie4g_temp AS

SELECT DISTINCT
  snap4g_ltecell.enbequipment, 
  snap4g_enb.macroenbid, 
  snap4g_ltecell.ltecell, 
  snap4g_ltecell.relativecellidentity,
  (to_number(snap4g_enb.macroenbid, '999999999')*256 + to_number(snap4g_ltecell.relativecellidentity, '999999999'))::text AS eci, 
  snap4g_ltecell.administrativestate, 
  snap4g_ltecell.operationalstate, 
  snap4g_ltecell.availabilitystatus, 
  snap4g_ltecell.aliasname, 
  snap4g_frequencyandbandwidth.dlbandwidth, 
  snap4g_frequencyandbandwidth.dlearfcn, 
  snap4g_ltecell.pci, 
  snap4g_ltecell.trackingareacode::bit(16)::integer,
  replace(snap4g_ltecell.cellazimuth,'unset','0') AS cellazimuth, 
  replace(snap4g_ltecell.mainantennapositionlongitude,'unset','0') AS mainantennapositionlongitude, 
  replace(snap4g_ltecell.mainantennapositionlatitude,'unset','0') AS mainantennapositionlatitude,
  replace(snap4g_ltecell.mainantennapositionaltitude,'unset','0') AS mainantennapositionaltitude,
  CASE WHEN dlearfcn = '6400' THEN 0.17 
	WHEN dlearfcn = '3000' THEN 0.1
	WHEN dlearfcn = '1331' THEN 0.13
	ELSE 0.5 END 
	AS piano_size_km,
  snap4g_ltecell.cellradius,
  --replace(snap4g_ltecell.dedicatedconfid,'DedicatedConf/','') AS dedicatedconfid,
  snap4g_cellactivationservice.prachpreambleformat, 
  snap4g_cellrachconf.nbrofrarsperrachcycle, 
  snap4g_cellrachconf.raresponsewindowsize, 
  snap4g_cellrachconf.rachmsg2startrb
FROM 
  public.snap4g_ltecell 
  LEFT JOIN public.snap4g_enb
    ON
      snap4g_ltecell.enbequipment = snap4g_enb.enbequipment AND
      snap4g_ltecell.enb = snap4g_enb.enb
  LEFT JOIN public.snap4g_cellactivationservice
    ON 
      snap4g_ltecell.enbequipment = snap4g_cellactivationservice.enbequipment AND
      snap4g_ltecell.ltecell = snap4g_cellactivationservice.ltecell
  LEFT JOIN public.snap4g_cellrachconf
    ON
      snap4g_ltecell.enbequipment = snap4g_cellrachconf.enbequipment AND
      snap4g_ltecell.ltecell = snap4g_cellrachconf.ltecell
  LEFT JOIN public.snap4g_frequencyandbandwidth
    ON
      snap4g_ltecell.enbequipment = snap4g_frequencyandbandwidth.enbequipment AND
      snap4g_ltecell.ltecell = snap4g_frequencyandbandwidth.ltecell
;


-- Creation de la table finale:
DROP TABLE IF EXISTS t_topologie4g;
CREATE TABLE t_topologie4g AS

SELECT DISTINCT
  t_topologie4g_temp.*,
  "GN",
  "NUM",
  "OPERATION",
  "CANDIDAT",
  "ETAT_DEPL",
  "ETAT_FONCT",
  "ETAT|$|",
  "DR",
  "UR",
  "X",
  "Y",
  "Z",
  "ADRESSE",
  "CODE_POSTAL",
  "VILLE|$|",	
  antennatype,
  azimut,
  tiltmeca,
  hauteursol,
  tiltelec800,
  tiltelec1800,
  tiltelec2600
FROM 
  t_topologie4g_temp
  LEFT JOIN public.t_noria_topo4g
    ON
      eci = t_noria_topo4g."IDRESEAUCELLULE"
ORDER BY
  ltecell ASC;

DROP TABLE IF EXISTS t_topologie4g_temp;
