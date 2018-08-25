DROP TABLE IF EXISTS t_fddcell_generic_corrections_new;
CREATE TABLE t_fddcell_generic_corrections_new AS

SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  t_topologie3g.nodeb,
  t_topologie3g.fddcell,
  snap3g_btscell.btsequipment,
  snap3g_btscell.btscell,
  --bdref_incohparam_cell."Paramètre" AS param_name, 
  --parametre text,
  bdref_fddcell_param_mapping.ran_path,
  bdref_fddcell_param_mapping.param_name,
  bdref_incohparam_cell."Valeur" AS param_value
FROM 
  public.bdref_incohparam_cell, 
  public.t_topologie3g, 
  public.snap3g_rnc,
  public.snap3g_btscell,
 public.bdref_fddcell_param_mapping
WHERE 
  bdref_incohparam_cell."LCID" = t_topologie3g.localcellid AND
  t_topologie3g.rnc = snap3g_rnc.rnc AND
  t_topologie3g.fddcell = snap3g_btscell.associatedfddcell AND
  bdref_fddcell_param_mapping.parametre = bdref_incohparam_cell."Paramètre"
  ;
