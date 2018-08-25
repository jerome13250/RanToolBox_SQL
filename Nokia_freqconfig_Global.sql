SELECT
  "SBTSId", 
  string_agg(freq, '-' ORDER BY freq) AS freq_config
FROM 
  ( 
  --Sous requete 3G:
  SELECT DISTINCT
	"nokia_WBTS"."SBTSId", 
	'U' || "nokia_WCEL"."UARFCN" AS freq
	FROM "nokia_WCEL" INNER JOIN "nokia_WBTS"
	   ON
		"nokia_WCEL"."managedObject_distName_parent" = "nokia_WBTS"."managedObject_distName"


  UNION

  SELECT DISTINCT
	"nokia_SBTS"."managedObject_SBTS" AS "SBTSId", 
	'L' || "nokia_LNCEL"."earfcnDL" AS freq
	FROM "nokia_LNCEL" INNER JOIN "nokia_LNBTS"
	   ON
		"nokia_LNCEL"."managedObject_distName_parent" = "nokia_LNBTS"."managedObject_distName"
	   INNER JOIN "nokia_SBTS"
	   ON
		"nokia_LNBTS"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"

  ORDER BY freq
	
	
  
	
  ) AS t

GROUP BY
  t."SBTSId"



