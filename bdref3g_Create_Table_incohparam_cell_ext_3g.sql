DROP TABLE IF EXISTS t_remotefddcell_generic_corrections;
CREATE TABLE t_remotefddcell_generic_corrections AS

SELECT 
  snap3g_rnc.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_rnc.clusterid, 
  snap3g_remotefddcell.remotefddcell, 
  incohs."Paramètre" AS param_name, 
  incohs."Valeur" AS param_value
FROM 
  public.bdref_visuincohparam_cell_ext_3g incohs, 
  public.snap3g_rnc, 
  public.snap3g_remotefddcell
WHERE 
  incohs."RNC" = snap3g_rnc.rnc AND
  incohs."RNC" = snap3g_remotefddcell.rnc AND
  incohs."LCID" = snap3g_remotefddcell.localcellid
ORDER BY
  snap3g_rnc.rnc,
  remotefddcell,
  param_name;
