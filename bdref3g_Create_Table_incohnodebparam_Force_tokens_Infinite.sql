--This query creates the table with bdref format to change all tokens to infinite
--Capacity_edchNumberUserCapacityLicensing
--Capacity_hsdpaNumberUserCapacityLicensing
--Capacity_r99NumberCECapacityLicensing

DROP TABLE IF EXISTS t_nodeb_generic_corrections_new;
CREATE TABLE t_nodeb_generic_corrections_new AS

SELECT DISTINCT --Capacity_edchNumberUserCapacityLicensing
  snap3g_rnc.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  snap3g_nodeb.nodeb,
  snap3g_capacity.btsequipment, 
  'BTSEquipment¤Capacity[0]' AS ran_path,
  'edchNumberUserCapacityLicensing' AS param_name,
  'infinite'::text AS param_value
FROM 
  public.snap3g_capacity INNER JOIN public.snap3g_btsequipment
    ON snap3g_capacity.btsequipment = snap3g_btsequipment.btsequipment
  INNER JOIN public.snap3g_nodeb 
    ON snap3g_btsequipment.associatednodeb = snap3g_nodeb.nodeb
  INNER JOIN public.snap3g_rnc 
    ON snap3g_nodeb.rnc = snap3g_rnc.rnc
WHERE 
  snap3g_capacity.edchnumberusercapacitylicensing != 'infinite'

UNION --Capacity_hsdpaNumberUserCapacityLicensing

SELECT DISTINCT
  snap3g_rnc.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  snap3g_nodeb.nodeb,
  snap3g_capacity.btsequipment, 
  'BTSEquipment¤Capacity[0]' AS ran_path,
  'hsdpaNumberUserCapacityLicensing' AS param_name,
  'infinite'::text AS param_value
FROM 
  public.snap3g_capacity INNER JOIN public.snap3g_btsequipment
    ON snap3g_capacity.btsequipment = snap3g_btsequipment.btsequipment
  INNER JOIN public.snap3g_nodeb 
    ON snap3g_btsequipment.associatednodeb = snap3g_nodeb.nodeb
  INNER JOIN public.snap3g_rnc 
    ON snap3g_nodeb.rnc = snap3g_rnc.rnc
WHERE 
  snap3g_capacity.hsdpaNumberUserCapacityLicensing != 'infinite'

UNION --Capacity_r99NumberCECapacityLicensing

SELECT DISTINCT
  snap3g_rnc.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  snap3g_nodeb.nodeb,
  snap3g_capacity.btsequipment, 
  'BTSEquipment¤Capacity[0]' AS ran_path,
  'r99NumberCECapacityLicensing' AS param_name,
  'infinite'::text AS param_value
FROM 
  public.snap3g_capacity INNER JOIN public.snap3g_btsequipment
    ON snap3g_capacity.btsequipment = snap3g_btsequipment.btsequipment
  INNER JOIN public.snap3g_nodeb 
    ON snap3g_btsequipment.associatednodeb = snap3g_nodeb.nodeb
  INNER JOIN public.snap3g_rnc 
    ON snap3g_nodeb.rnc = snap3g_rnc.rnc
WHERE 
  snap3g_capacity.r99NumberCECapacityLicensing != 'infinite'

ORDER BY
  btsequipment
  ;
