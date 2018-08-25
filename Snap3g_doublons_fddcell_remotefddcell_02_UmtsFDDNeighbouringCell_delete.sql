﻿DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_delete;
CREATE TABLE t_umtsfddneighbouringcell_generic_delete AS

SELECT 
  snap3g_umtsfddneighbouringcell.rnc, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid,
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_umtsfddneighbouringcell.nodeb, 
  snap3g_umtsfddneighbouringcell.fddcell, 
  snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell
FROM 
  public.tmp_doublons_fddcell_remotefddcell, 
  public.snap3g_umtsfddneighbouringcell, 
  public.snap3g_rnc
WHERE 
  tmp_doublons_fddcell_remotefddcell.rnc = snap3g_umtsfddneighbouringcell.rnc AND
  tmp_doublons_fddcell_remotefddcell.remotefddcell = snap3g_umtsfddneighbouringcell.umtsfddneighbouringcell AND
  snap3g_umtsfddneighbouringcell.rnc = snap3g_rnc.rnc
ORDER BY 
  rnc,
  fddcell,
  umtsfddneighbouringcell;
