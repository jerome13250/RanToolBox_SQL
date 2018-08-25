DROP TABLE IF EXISTS t_neighbouringrnc_generic_corrections;
CREATE TABLE t_neighbouringrnc_generic_corrections AS

SELECT 
  snap3g_neighbouringrnc.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid,'Cluster/','') AS clusterid, 
  snap3g_neighbouringrnc.neighbouringrnc,
  'isInterFreqHandoverOverIurAllowed'::text AS parametre,
  'false'::text AS valeur
FROM 
  public.snap3g_neighbouringrnc INNER JOIN public.snap3g_rnc
  ON
	snap3g_neighbouringrnc.rnc = snap3g_rnc.rnc
WHERE 
  neighbouringrnc IN ('419','58','57','358','359','439','438') AND
  snap3g_neighbouringrnc.isinterfreqhandoveroveriurallowed = 'true'


;
