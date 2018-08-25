SELECT DISTINCT
  "managedObject_distName_parent", 
  string_agg("UARFCN", '-' ORDER BY "UARFCN") AS freq_config
FROM 
  ( SELECT DISTINCT
	"nokia_WCEL"."managedObject_distName_parent", 
	"nokia_WCEL"."UARFCN"
	FROM "nokia_WCEL"
	ORDER BY "UARFCN"
  ) AS t

GROUP BY
  t."managedObject_distName_parent" 
