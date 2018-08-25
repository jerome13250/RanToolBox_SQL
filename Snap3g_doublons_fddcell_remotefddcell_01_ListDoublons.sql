--Cree la liste des RemoteFDDCell qui existent en même temps que le FDDCell sur le même RNC
DROP TABLE IF EXISTS tmp_doublons_fddcell_remotefddcell;
CREATE TABLE tmp_doublons_fddcell_remotefddcell AS

SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.remotefddcell
FROM 
  public.snap3g_remotefddcell, 
  public.snap3g_fddcell
WHERE 
  snap3g_remotefddcell.rnc = snap3g_fddcell.rnc AND
  snap3g_remotefddcell.remotefddcell = snap3g_fddcell.fddcell
ORDER BY
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.remotefddcell;

