SELECT 
  "nokia_BCF"."managedObject_version", 
  "nokia_BCF"."managedObject_id", 
  "nokia_BCF"."managedObject_distName", 
  "nokia_BCF"."managedObject_BCF", 
  "nokia_BCF"."SBTSId", 
  "nokia_BCF".name, 
  "nokia_SBTS".name, 
  "nokia_SBTS"."sbtsName"
FROM 
  public."nokia_BCF" LEFT JOIN public."nokia_SBTS"
  ON
    "nokia_BCF"."SBTSId" = "nokia_SBTS"."managedObject_SBTS";
