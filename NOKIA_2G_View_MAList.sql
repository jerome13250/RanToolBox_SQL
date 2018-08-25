SELECT 
  "nokia_BTS"."managedObject_distName", 
  "nokia_BTS".name, 
  "nokia_BTS"."cellId",
  "locationAreaIdLAC",
  "locationAreaIdMCC",
  "locationAreaIdMNC",
  "nokia_BTS"."bsIdentityCodeBCC",
  "nokia_BTS"."bsIdentityCodeNCC",
  "maioOffset",
  "maioStep",
  "nokia_MAL"."managedObject_distName" AS "MAL_distName", 
  "nokia_MAL"."managedObject_MAL", 
  "nokia_MAL"."frequencyBandInUse", 
  string_agg("nokia_MAL_frequency".p_noname, '_' ORDER BY p_noname::int) AS "MA"
FROM 
  public."nokia_BTS" INNER JOIN public."nokia_BCF"
  ON
    "nokia_BTS"."managedObject_distName_parent" = "nokia_BCF"."managedObject_distName" 
  LEFT JOIN public."nokia_MAL"
  ON
     "nokia_BCF"."managedObject_distName_parent" = "nokia_MAL"."managedObject_distName_parent" AND
     "nokia_BTS"."usedMobileAllocation" = "nokia_MAL"."managedObject_MAL"
  LEFT JOIN public."nokia_MAL_frequency"
  ON
    "nokia_MAL"."managedObject_id" = "nokia_MAL_frequency"."managedObject_id" AND
    "nokia_MAL"."managedObject_distName" = "nokia_MAL_frequency"."managedObject_distName" AND
    "nokia_MAL"."managedObject_distName_parent" = "nokia_MAL_frequency"."managedObject_distName_parent"

GROUP BY
  "nokia_BTS"."managedObject_distName", 
  "nokia_BTS".name, 
  "nokia_BTS"."cellId",
  "locationAreaIdLAC",
  "locationAreaIdMCC",
  "locationAreaIdMNC",
  "nokia_BTS"."bsIdentityCodeBCC",
  "nokia_BTS"."bsIdentityCodeNCC",
  "maioOffset",
  "maioStep",
  "nokia_MAL"."managedObject_distName", 
  "nokia_MAL"."managedObject_MAL", 
  "nokia_MAL"."frequencyBandInUse"
ORDER BY
  "nokia_BTS".name

;
