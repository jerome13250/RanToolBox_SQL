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


INSERT INTO t_topologie3g (rnc, rncid, fddcell,cellid,dlfrequencynumber,ulfrequencynumber,localcellid,locationareacode,
							routingareacode,primaryscramblingcode,mobilecountrycode,mobilenetworkcode,
							edchactivation,hsdpaactivation,multirabsmartedchresourceusageactivation)
SELECT DISTINCT
  t_topologie3g_nokia."RNCName" AS rnc, 
  t_topologie3g_nokia."RNC_id" AS rncid, 
  t_topologie3g_nokia.name AS fddcell, 
  t_topologie3g_nokia."CId" AS cellid, 
  t_topologie3g_nokia."UARFCN" AS dlfrequencynumber,
  ulfrequencycalcul(t_topologie3g_nokia."UARFCN") AS ulfrequencynumber, 
  t_topologie3g_nokia."managedObject_WCEL" AS localcellid, 
  t_topologie3g_nokia."LAC" AS locationareacode, 
  t_topologie3g_nokia."RAC" AS routingareacode, 
  t_topologie3g_nokia."PriScrCode" AS primaryscramblingcode, 
  t_topologie3g_nokia."WCELMCC" AS mobilecountrycode, 
  t_topologie3g_nokia."WCELMNC" AS mobilenetworkcode,
  'false' AS edchactivation,
  'true' AS hsdpaactivation,
  'false' AS multirabsmartedchresourceusageactivation
FROM 
  public.t_topologie3g_nokia LEFT JOIN public.t_topologie3g
  ON 
     t_topologie3g_nokia."managedObject_WCEL" = t_topologie3g.localcellid
WHERE
  t_topologie3g.localcellid IS NULL AND
  t_topologie3g_nokia."WBTS_managedObject_distName" NOT LIKE 'PLMN-PLMN/EXCCU-1';
