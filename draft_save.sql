SELECT DISTINCT
  "nokia_WNCEL"."managedObject_version", 
  "nokia_WNCEL"."managedObject_distName", 
  "nokia_WNCEL"."managedObject_WNCEL", 
  "nokia_CHANNEL"."antlDN", 
  "nokia_ANTL"."feederLoss"
FROM 
  public."nokia_LCELW" INNER JOIN public."nokia_CHANNELGROUP", 
  ON
	"nokia_LCELW"."managedObject_distName" = "nokia_CHANNELGROUP"."managedObject_distName_parent"
  INNER JOIN public."nokia_CHANNEL"
  ON
	"nokia_CHANNEL"."managedObject_distName_parent" = "nokia_CHANNELGROUP"."managedObject_distName"
  INNER JOIN public."nokia_WNCEL"
  ON
	"nokia_WNCEL"."lCelwDN" = "nokia_LCELW"."managedObject_distName"
  INNER JOIN public."nokia_ANTL"
  ON
	"nokia_CHANNEL"."antlDN" = "nokia_ANTL"."managedObject_distName"
  
ORDER BY
  "nokia_WNCEL"."managedObject_distName" ASC, 
  "nokia_CHANNEL"."antlDN" ASC;
