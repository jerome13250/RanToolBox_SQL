DROP TABLE IF EXISTS t_remotefddcell_generic_delete;
CREATE TABLE t_remotefddcell_generic_delete AS

SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_remotefddcell.remotefddcell
FROM 
  public.tmp_doublons_fddcell_remotefddcell, 
  public.snap3g_remotefddcell, 
  public.snap3g_rnc
WHERE 
  tmp_doublons_fddcell_remotefddcell.rnc = snap3g_remotefddcell.rnc AND
  tmp_doublons_fddcell_remotefddcell.remotefddcell = snap3g_remotefddcell.remotefddcell AND
  snap3g_remotefddcell.rnc = snap3g_rnc.rnc
ORDER BY
  rnc,
  remotefddcell;
