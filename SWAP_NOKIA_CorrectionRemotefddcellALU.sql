DROP TABLE IF EXISTS t_remotefddcell_generic_corrections;
CREATE TABLE t_remotefddcell_generic_corrections AS
SELECT
  snap3g_remotefddcell.remotefddcell, 
  snap3g_rnc.rnc,
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease,
  'neighbouringRNCId'::text AS param_name,
  regexp_replace(replace("nokia_WCEL"."managedObject_distName",'PLMN-PLMN/RNC-',''), '/.*','') AS param_value
  
FROM 
  public.swap_list_lcid INNER JOIN public.snap3g_remotefddcell
  ON
	swap_list_lcid."LCID" = snap3g_remotefddcell.localcellid
  INNER JOIN public."nokia_WCEL"
  ON
	swap_list_lcid."LCID" = "nokia_WCEL"."managedObject_WCEL"
  INNER JOIN snap3g_rnc
  ON
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc

UNION

SELECT
  snap3g_remotefddcell.remotefddcell, 
  snap3g_rnc.rnc,
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease,
  'routingAreaCode'::text AS param_name,
  '2'::text AS param_value
 
FROM 
  public.swap_list_lcid INNER JOIN public.snap3g_remotefddcell
  ON
	swap_list_lcid."LCID" = snap3g_remotefddcell.localcellid
  INNER JOIN public."nokia_WCEL"
  ON
	swap_list_lcid."LCID" = "nokia_WCEL"."managedObject_WCEL"
  INNER JOIN snap3g_rnc
  ON
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc;