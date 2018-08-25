CREATE OR REPLACE VIEW v_cemboardnum AS
SELECT 
  btsequipment,
  count(btsequipment) AS cemboard_number
FROM 
  public.snap3g_board
WHERE 
  moduletype IN ('36','37','86')
GROUP BY 
  btsequipment

ORDER BY
  btsequipment;
  
  CREATE OR REPLACE VIEW v_hsxparesourceNum AS
SELECT 
  snap3g_hsxparesource.btsequipment, 
  count(snap3g_hsxparesource.hsxparesource) AS hsxparesource_number
FROM 
  public.snap3g_hsxparesource
GROUP BY snap3g_hsxparesource.btsequipment;

CREATE OR REPLACE VIEW v_pcmNum AS
SELECT 
  snap3g_pcm.btsequipment, 
  count(snap3g_pcm.pcm) AS pcm_number
FROM 
  public.snap3g_pcm
GROUP BY snap3g_pcm.btsequipment;



DROP TABLE IF EXISTS T_topologie3g;

CREATE TABLE T_topologie3g AS
SELECT DISTINCT
  snap3g_fddcell.rnc,
  snap3g_rnc.rncid,
  snap3g_rnc.provisionedsystemrelease,
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  snap3g_fddcell.nodeb,
  replace(snap3g_btsequipment.runningsoftwareversion,'NODE-B ','') AS runningsoftwareversion,
  snap3g_fddcell.fddcell,
  snap3g_btscell.btsequipment,
  snap3g_btscell.btscell,
  snap3g_fddcell.cellid,
  (to_number(snap3g_rnc.rncid,'99999')*65536 + to_number(snap3g_fddcell.cellid,'99999'))::text AS alcatel_cellcode_ct, 
  snap3g_fddcell.dlfrequencynumber,
  snap3g_fddcell.ulfrequencynumber,
  snap3g_fddcell.localcellid, 
  snap3g_fddcell.locationareacode, 
  snap3g_fddcell.routingareacode,
  snap3g_fddcell.serviceareacode,
  snap3g_fddcell.uraidentitylist,
  snap3g_fddcell.primaryscramblingcode,
  snap3g_fddcell.mobilecountrycode,
  snap3g_fddcell.mobilenetworkcode,
  left(right(snap3g_fddcell.fddcell,2),1) AS sector_number,
  replace(snap3g_btsequipment.unknownstatus,'unknownstatus','') AS unknownstatus,
  snap3g_fddcell.administrativestate,
  snap3g_fddcell.operationalstate,
  snap3g_fddcell.availabilitystatus,
  snap3g_btscell.cellsize,
  replace(snap3g_fddcell.cellselectionprofileid,'CellProfiles/0 CellSelectionProfile/','') AS cellselectionprofileid,
  replace(snap3g_fddcell.cellselectionwithpriorityprofileid,'CellProfiles/0 CellSelectionWithPriorityProfile/','') AS cellselectionwithpriorityprofileid,
  snap3g_fddintelligentmulticarriertrafficallocation.mode,
  replace(snap3g_fddintelligentmulticarriertrafficallocation.serviceprioritygeneraltableconfclassid,'RadioAccessService/0 Imcta/0 ServicePriorityGeneralTableConfClass/','') AS serviceprioritygeneraltableconfclassid,
  replace(snap3g_fddintelligentmulticarriertrafficallocation.serviceprioritytableforhsdpaconfclassid,'RadioAccessService/0 Imcta/0 ServicePriorityTableForHsdpaConfClass/','') AS serviceprioritytableforhsdpaconfclassid,
  replace(snap3g_fddintelligentmulticarriertrafficallocation.serviceprioritytableforhsupaconfclassid,'RadioAccessService/0 Imcta/0 ServicePriorityTableForHsupaConfClass/','') AS serviceprioritytableforhsupaconfclassid,
  snap3g_fddcell.twingsmcelluserlabellist,
  replace(snap3g_fddintelligentmulticarriertrafficallocation.alarmprioritytableconfclassid,'RadioAccessService/0 Imcta/0 AlarmPriorityTableConfClass/','') AS alarmprioritytableconfclassid,
  replace(snap3g_fddcell.hoconfid,'RadioAccessService/0 DedicatedConf/0 HoConfClass/','') AS hoconfid,
  replace(snap3g_edchresource.edchcellclassid,'RadioAccessService/0 DedicatedConf/0 EdchCellClass/','') AS edchcellclassid,
  replace(snap3g_fddcell.powerconfid, 'RadioAccessService/0 DedicatedConf/0 PowerConfClass/','') AS powerconfid,
  snap3g_fddcell.edchactivation, --Ajouté pour la creation par wo des remotefddcell
  snap3g_fddcell.hsdpaactivation, --Ajouté pour la creation par wo des remotefddcell
  snap3g_fddcell.multirabsmartedchresourceusageactivation, --Ajouté pour la creation par wo des remotefddcell
  replace(snap3g_fddcell.azimuthantennaangle,'unset','') AS azimuth,
  snap3g_app.longitude,
  snap3g_app.latitude, 
  v_pcmnum.pcm_number,
  snap3g_ipran.attachrncipaddress AS ipran_attachrncipaddress,
  v_hsxparesourcenum.hsxparesource_number,
  v_cemboardnum.cemboard_number,
  replace(snap3g_hsdpaconf.hsxparesourceid,'HsXpaResource/','') AS hsxparesourceid,
  snap3g_btscell.localcellgroupid,
  snap3g_localcellgroup.r99resourceid, 
  snap3g_localcellgroup.frequencygroupid

FROM 
  public.snap3g_rnc INNER JOIN public.snap3g_fddcell ON snap3g_rnc.rnc = snap3g_fddcell.rnc
  INNER JOIN public.snap3g_app ON snap3g_fddcell.fddcell = snap3g_app.fddcell
  LEFT JOIN public.v_pcmnum ON snap3g_fddcell.nodeb = v_pcmnum.btsequipment
  LEFT JOIN snap3g_ipran ON snap3g_fddcell.nodeb = snap3g_ipran.btsequipment
  LEFT JOIN public.v_hsxparesourcenum ON snap3g_fddcell.nodeb = v_hsxparesourcenum.btsequipment
  LEFT JOIN public.v_cemboardnum ON snap3g_fddcell.nodeb = v_cemboardnum.btsequipment
  LEFT JOIN public.snap3g_btscell ON snap3g_btscell.associatedfddcell = snap3g_fddcell.fddcell
  LEFT JOIN public.snap3g_hsdpaconf ON snap3g_btscell.btsequipment = snap3g_hsdpaconf.btsequipment AND snap3g_btscell.btscell = snap3g_hsdpaconf.btscell
  LEFT JOIN public.snap3g_edchresource ON snap3g_edchresource.fddcell = snap3g_fddcell.fddcell
  LEFT JOIN public.snap3g_btsequipment ON snap3g_btsequipment.btsequipment = snap3g_fddcell.nodeb
  LEFT JOIN snap3g_fddintelligentmulticarriertrafficallocation ON snap3g_fddcell.fddcell = snap3g_fddintelligentmulticarriertrafficallocation.fddcell
  LEFT JOIN public.snap3g_localcellgroup 
  ON 
	snap3g_btscell.btsequipment = snap3g_localcellgroup.btsequipment AND
	snap3g_btscell.localcellgroupid = snap3g_localcellgroup.localcellgroup


ORDER BY
  snap3g_fddcell.fddcell ASC;

--ALTER TABLE T_topologie3g ADD COLUMN hsxparesource TEXT;
ALTER TABLE T_topologie3g ADD COLUMN codenidt TEXT;

INSERT INTO T_topologie3g (rnc, rncid, fddcell,cellid,alcatel_cellcode_ct,dlfrequencynumber,ulfrequencynumber,localcellid,locationareacode,
							routingareacode,primaryscramblingcode,mobilecountrycode,mobilenetworkcode,sector_number,
							edchactivation,hsdpaactivation,multirabsmartedchresourceusageactivation)
SELECT
  'EXTERNAL' AS rnc, 
  snap3g_remotefddcell.neighbouringrncid,
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.neighbouringfddcellid, 
  (to_number(snap3g_remotefddcell.neighbouringrncid,'99999')*65536 + to_number(snap3g_remotefddcell.neighbouringfddcellid,'99999'))::text, 
  snap3g_remotefddcell.dlfrequencynumber,
  snap3g_remotefddcell.ulfrequencynumber,  
  snap3g_remotefddcell.localcellid,
  snap3g_remotefddcell.locationareacode,
  snap3g_remotefddcell.routingareacode,
  snap3g_remotefddcell.primaryscramblingcode,
  snap3g_remotefddcell.mobilecountrycode,
  snap3g_remotefddcell.mobilenetworkcode,
  left(right(snap3g_remotefddcell.remotefddcell,2),1),
  MIN(snap3g_remotefddcell.isedchallowed), --Ajouté pour la creation par wo des remotefddcell
  MIN(snap3g_remotefddcell.ishsdpaallowed), --Ajouté pour la creation par wo des remotefddcell
  MIN(snap3g_remotefddcell.multirabsmartedchresourceusageactivation) --Ajouté pour la creation par wo des remotefddcell
FROM 
  public.snap3g_remotefddcell LEFT JOIN public.snap3g_rnc ON snap3g_rnc.rncid = snap3g_remotefddcell.neighbouringrncid
WHERE 
  snap3g_rnc.rncid IS NULL
GROUP BY
  snap3g_remotefddcell.neighbouringrncid,
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.neighbouringfddcellid, 
  snap3g_remotefddcell.neighbouringrncid,
  snap3g_remotefddcell.neighbouringfddcellid,
  snap3g_remotefddcell.dlfrequencynumber,
  snap3g_remotefddcell.ulfrequencynumber,  
  snap3g_remotefddcell.localcellid,
  snap3g_remotefddcell.locationareacode,
  snap3g_remotefddcell.routingareacode,
  snap3g_remotefddcell.primaryscramblingcode,
  snap3g_remotefddcell.mobilecountrycode,
  snap3g_remotefddcell.mobilenetworkcode
 ORDER BY
  snap3g_remotefddcell.remotefddcell ASC
  ;

 
--Rajoute les colonnes utiles pour les donnees NORIA
ALTER TABLE t_topologie3g
    ADD COLUMN antenna TEXT,
    ADD COLUMN tilt_meca TEXT,
    ADD COLUMN hba TEXT,
    ADD COLUMN tilt_elec_u2200 TEXT,
    ADD COLUMN tilt_elec_u900 TEXT,
    ADD COLUMN pertes_p2_2100 TEXT;

-- Mise a jour des coordonnees X Y
UPDATE t_topologie3g AS t
 SET 
  azimuth = n."AZIMUT",
  longitude = n."X", 
  latitude = n."Y",
  codenidt = n."GN",
  antenna = n."CAT_REF",
  tilt_meca = n."TILT_MECANIQUE",
  hba = n."HAUTEUR_SOL",
  tilt_elec_u2200 = n."TILT_ELECTRIQUE_UMTS2200",
  tilt_elec_u900 = n."TILT_ELECTRIQUE_UMTS900",
  pertes_p2_2100 = n."PERTES_P2_UMTS2200_MAIN"
  
 FROM 
  public.t_noria_topo_3g AS n
WHERE 
  t.localcellid = n."IDRESEAUCELLULE";

--Suppression de versions fantomes sur la_begude:
DELETE FROM t_topologie3g
  WHERE 
  t_topologie3g.nodeb = 'LA_BEGUDE' AND 
  t_topologie3g.runningsoftwareversion = 'unset';


  
 -- Creation des index pour accelerer les requetes
CREATE INDEX ind_fddcell
ON t_topologie3g (fddcell);
CREATE INDEX ind_dlfrequencynumber
ON t_topologie3g (dlfrequencynumber);
CREATE INDEX ind_localcellid
ON t_topologie3g (localcellid);
CREATE INDEX ind_primaryscramblingcode
ON t_topologie3g (primaryscramblingcode);
CREATE INDEX ind_nodeb
ON t_topologie3g (nodeb);
CREATE INDEX ind_rnc
ON t_topologie3g (rnc);


DROP VIEW v_cemboardnum;
DROP VIEW v_hsxparesourcenum;
DROP VIEW v_pcmnum;