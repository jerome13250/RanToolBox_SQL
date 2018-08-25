DROP TABLE IF EXISTS t_remotefddcell_generic_delete;
CREATE TABLE t_remotefddcell_generic_delete AS

SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_rnc.clusterid, 
  snap3g_remotefddcell.umtsneighbouring, 
  snap3g_remotefddcell.remotefddcell
FROM 
  public.snap3g_remotefddcell LEFT JOIN public.snap3g_umtsfddneighbouringcell 
  ON 
    snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell = snap3g_remotefddcell.remotefddcell AND
    snap3g_umtsfddneighbouringcell.rnc = snap3g_remotefddcell.rnc
  INNER JOIN public.snap3g_rnc
  ON
    snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell IS NULL
  ;
