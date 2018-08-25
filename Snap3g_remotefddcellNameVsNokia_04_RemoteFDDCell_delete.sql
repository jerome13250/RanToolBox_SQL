DROP TABLE IF EXISTS t_remotefddcell_generic_delete;
CREATE TABLE t_remotefddcell_generic_delete AS

SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_remotefddcell.remotefddcell,
  tmp_remotefddcell_namenotlikenokia.name AS info_futur_name
FROM 
  public.tmp_remotefddcell_namenotlikenokia, 
  public.snap3g_remotefddcell, 
  public.snap3g_rnc
WHERE 
  tmp_remotefddcell_namenotlikenokia.rnc = snap3g_remotefddcell.rnc AND
  tmp_remotefddcell_namenotlikenokia.remotefddcell = snap3g_remotefddcell.remotefddcell AND
  snap3g_remotefddcell.rnc = snap3g_rnc.rnc
ORDER BY
  rnc,
  remotefddcell;
