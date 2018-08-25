--Calcule les doublons de BTSAdditionalInfo utilisés:
SELECT 
  "nokia_WBTS"."managedObject_distName",
  name,
  "nokia_WBTS"."BTSAdditionalInfo",
  ''::text AS "sbtsDescription"
FROM "nokia_WBTS"
WHERE
  "BTSAdditionalInfo" IN 
	(
		SELECT 
		  "nokia_WBTS"."BTSAdditionalInfo"
		FROM 
		  public."nokia_WBTS"
		GROUP BY
		  "nokia_WBTS"."BTSAdditionalInfo"
		HAVING
		  COUNT("nokia_WBTS"."BTSAdditionalInfo")>1
	)

UNION

---Calcule les doublons de BTSAdditionalInfo utilisés:
SELECT 
  "nokia_SBTS"."managedObject_distName",
  name,
  ''::text,
  "nokia_SBTS"."sbtsDescription"
FROM "nokia_SBTS"
WHERE
  "sbtsDescription" IN 
	(
		SELECT 
		  "nokia_SBTS"."sbtsDescription"
		FROM 
		  public."nokia_SBTS"
		GROUP BY
		  "nokia_SBTS"."sbtsDescription"
		HAVING
		  COUNT("nokia_SBTS"."sbtsDescription")>1
	)

ORDER BY "BTSAdditionalInfo","sbtsDescription"

;
