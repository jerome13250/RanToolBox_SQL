SELECT 
  "nokia_ADJL"."managedObject_ADJL",
  COUNT("nokia_ADJL"."managedObject_ADJL") AS COUNT, 
  "nokia_ADJL"."AdjLEARFCN", 
  "nokia_ADJL"."AdjLMeasBw", 
  "nokia_ADJL"."AdjLSelectFreq", 
  "nokia_ADJL"."HopLIdentifier", 
  MAX("nokia_ADJL".name)
FROM 
  public."nokia_ADJL"
WHERE 
  "nokia_ADJL"."managedObject_distName" LIKE '%WCEL%'
GROUP BY 
  "nokia_ADJL"."managedObject_ADJL",
  "nokia_ADJL"."AdjLEARFCN", 
  "nokia_ADJL"."AdjLMeasBw", 
  "nokia_ADJL"."AdjLSelectFreq" ,
  "nokia_ADJL"."HopLIdentifier"
ORDER BY
    "nokia_ADJL"."managedObject_ADJL",
    COUNT("nokia_ADJL"."managedObject_ADJL") desc
;
