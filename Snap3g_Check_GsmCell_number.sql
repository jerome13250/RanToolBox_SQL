

SELECT * FROM crosstab
(
	$$
	SELECT 
	  snap3g_gsmcell.rnc,  
	  mobilecountrycode || '-' || mobilenetworkcode AS operator,
	  COUNT(snap3g_gsmcell.gsmcell)
	FROM 
	  public.snap3g_gsmcell
	GROUP BY
	  snap3g_gsmcell.rnc,  
	  mobilecountrycode || '-' || mobilenetworkcode

	UNION

	SELECT 
	  snap3g_gsmcell.rnc,  
	  'total'::text AS operator,
	  COUNT(snap3g_gsmcell.gsmcell)
	FROM 
	  public.snap3g_gsmcell
	GROUP BY
	  snap3g_gsmcell.rnc

        ORDER  BY 1,2  
	$$
      ,$$VALUES ('208-01'::text), ('208-10'::text), ('208-15'::text), ('208-20'::text), ('total'::text)$$
)
AS ct ("RNC" text, "OF" int, "SFR" int, "FRM" int, "BYT" int, "total" int);