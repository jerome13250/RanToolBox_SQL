--Fonction speciale de cacul uarfcn ul pour NOKIA
--RF band I: Allowed DL channel numbers are 10562-10838.
--RF band VIII: Allowed DL channel numbers are: 2937-3088.
CREATE OR REPLACE FUNCTION ulfrequencycalcul(dlfrequency text) RETURNS text
AS
$$
  SELECT TEXT(
	CASE	WHEN ($1)::integer >= 10562 AND ($1)::integer <= 10838 THEN ($1)::integer - 950 --RF band I
		WHEN ($1)::integer >= 2937 AND ($1)::integer <= 3088 THEN ($1)::integer - 225  --RF band VIII
		ELSE 0 END 
	) 
  ;
$$ LANGUAGE 'sql';



DROP TABLE IF EXISTS t_remotefddcell_generic_corrections;
CREATE TABLE t_remotefddcell_generic_corrections AS

SELECT --INCOH neighbouringRNCId:
  snap3g_remotefddcell.rnc,
  provisionedsystemrelease,
  clusterid,
  snap3g_remotefddcell.remotefddcell,
  'neighbouringRNCId' AS param_name,
  t_topologie3g_nokia."RNC_id" AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON 
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN snap3g_rnc 
  ON 
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  t_topologie3g_nokia."AdminCellState" = 'Unlocked' AND
  snap3g_remotefddcell.neighbouringrncid != t_topologie3g_nokia."RNC_id"

UNION   --INCOH neighbouringFDDCellId
SELECT 
  snap3g_remotefddcell.rnc,
  provisionedsystemrelease,
  clusterid, 
  snap3g_remotefddcell.remotefddcell,
  'neighbouringFDDCellId' AS param_name,
  t_topologie3g_nokia."CId" AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON 
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN snap3g_rnc 
  ON 
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  t_topologie3g_nokia."AdminCellState" = 'Unlocked' AND
  snap3g_remotefddcell.neighbouringFDDCellId != t_topologie3g_nokia."CId"

UNION   --INCOH locationAreaCode
SELECT 
  snap3g_remotefddcell.rnc,
  provisionedsystemrelease,
  clusterid, 
  snap3g_remotefddcell.remotefddcell,
  'locationAreaCode' AS param_name,
  t_topologie3g_nokia."LAC" AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON 
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN snap3g_rnc 
  ON 
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  t_topologie3g_nokia."AdminCellState" = 'Unlocked' AND
  snap3g_remotefddcell.locationAreaCode != t_topologie3g_nokia."LAC"


UNION   --INCOH routingAreaCode
SELECT 
  snap3g_remotefddcell.rnc,
  provisionedsystemrelease,
  clusterid, 
  snap3g_remotefddcell.remotefddcell,
  'routingAreaCode' AS param_name,
  t_topologie3g_nokia."RAC" AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON 
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN snap3g_rnc 
  ON 
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  t_topologie3g_nokia."AdminCellState" = 'Unlocked' AND
  snap3g_remotefddcell.routingAreaCode != t_topologie3g_nokia."RAC"

UNION   --INCOH dlFrequencyNumber
SELECT 
  snap3g_remotefddcell.rnc,
  provisionedsystemrelease,
  clusterid, 
  snap3g_remotefddcell.remotefddcell,
  'dlFrequencyNumber' AS param_name,
  t_topologie3g_nokia."UARFCN" AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON 
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN snap3g_rnc 
  ON 
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  t_topologie3g_nokia."AdminCellState" = 'Unlocked' AND
  snap3g_remotefddcell.dlFrequencyNumber != t_topologie3g_nokia."UARFCN"


UNION   --INCOH ulFrequencyNumber
SELECT 
  snap3g_remotefddcell.rnc,
  provisionedsystemrelease,
  clusterid, 
  snap3g_remotefddcell.remotefddcell,
  'ulFrequencyNumber' AS param_name,
  ulfrequencycalcul(t_topologie3g_nokia."UARFCN") AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON 
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN snap3g_rnc 
  ON 
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  t_topologie3g_nokia."AdminCellState" = 'Unlocked' AND
  snap3g_remotefddcell.ulFrequencyNumber != ulfrequencycalcul(t_topologie3g_nokia."UARFCN")


UNION   --INCOH primaryScramblingCode
SELECT 
  snap3g_remotefddcell.rnc,
  provisionedsystemrelease,
  clusterid, 
  snap3g_remotefddcell.remotefddcell,
  'primaryScramblingCode' AS param_name,
  t_topologie3g_nokia."PriScrCode" AS param_value
FROM 
  public.snap3g_remotefddcell INNER JOIN public.t_topologie3g_nokia
  ON 
	snap3g_remotefddcell.localcellid = t_topologie3g_nokia."managedObject_WCEL"
  INNER JOIN snap3g_rnc 
  ON 
	snap3g_remotefddcell.rnc = snap3g_rnc.rnc
WHERE
  t_topologie3g_nokia."AdminCellState" = 'Unlocked' AND
  snap3g_remotefddcell.primaryScramblingCode != t_topologie3g_nokia."PriScrCode"

ORDER BY
 remotefddcell,
 param_name