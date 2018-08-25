DROP TABLE IF EXISTS t_nodeb_generic_corrections_new;
CREATE TABLE t_nodeb_generic_corrections_new AS

SELECT 
  snap3g_rnc.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  snap3g_nodeb.nodeb,
  snap3g_nodeb.associatedbtsequipment AS btsequipment,
  bdref_nodeb_param_mapping.ran_path,
  bdref_nodeb_param_mapping.param_name,
  bdref_incohparam_nodeb."Valeur" AS param_value
FROM 
  public.bdref_incohparam_nodeb INNER JOIN public.snap3g_nodeb
  ON
    bdref_incohparam_nodeb."NODEB" = snap3g_nodeb.nodeb
  INNER JOIN public.snap3g_rnc
  ON
    snap3g_nodeb.rnc = snap3g_rnc.rnc
  INNER JOIN public.bdref_nodeb_param_mapping
  ON
    bdref_nodeb_param_mapping.parametre = bdref_incohparam_nodeb."Paramètre"
  ;
