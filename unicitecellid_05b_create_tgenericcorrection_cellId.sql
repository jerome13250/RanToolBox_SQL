--creation table finale en prenant en compte l'activation du dualcellid
DROP TABLE IF EXISTS t_fddcell_generic_corrections_new;
CREATE TABLE t_fddcell_generic_corrections_new AS
SELECT DISTINCT
  t_topologie3g.rnc, 
  t_topologie3g.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid, 'Cluster/','') AS clusterid,
  t_topologie3g.nodeb, 
  t_topologie3g.fddcell,
  tmp_unicitecellid_05_nouveauxcellid.cellid AS param_value,
  'cellId'::text AS param_name, 
  'RNC_NodeB_FDDCell' AS ran_path
FROM 
  public.tmp_unicitecellid_05_nouveauxcellid,
  public.t_topologie3g, 
  public.snap3g_rnc
WHERE 
  tmp_unicitecellid_05_nouveauxcellid.fddcell = t_topologie3g.fddcell AND
  t_topologie3g.rnc = snap3g_rnc.rnc 
 --filtre temporaire:
  --AND
  --t_topologie3g.cellid IN ('48356','58115')

 ;