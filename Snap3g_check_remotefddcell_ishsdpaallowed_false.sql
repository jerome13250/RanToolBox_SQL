DROP TABLE IF EXISTS t_remotefddcell_generic_modify;
CREATE TABLE t_remotefddcell_generic_modify AS

SELECT 
  snap3g_remotefddcell.rnc,
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease,  
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.neighbouringrncid, 
  'true'::text AS ishsdpaallowed
FROM 
  public.snap3g_remotefddcell, 
  public."nokia_RNC",
  public.snap3g_rnc
WHERE 
  snap3g_remotefddcell.neighbouringrncid =  "nokia_RNC"."managedObject_RNC" AND
  snap3g_remotefddcell.rnc = snap3g_rnc.rnc AND
  ishsdpaallowed = 'false';
