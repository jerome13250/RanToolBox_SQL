SELECT 
  t_topologie2g."SiteName",
  t_topologie2g."SiteID", 
  t_topologie2g."CellName",
  t_topologie2g."CellInstanceIdentifier", 
  t_topologie2g.lac, 
  t_topologie2g.ci, 
  t_topologie2g."AdministrativeState", 
  t_topologie2g."OperationalState", 
  t_topologie2g."AvailabilityStatus", 
  t_topologie2g."BCCHFrequency",
  t_topologie2g."HoppingSequenceNumber", 
  t_topologie2g."MobileAllocation", 
  "t_topologie2G_2"."SiteName", 
  "t_topologie2G_2"."CellName",
  "t_topologie2G_2"."CellInstanceIdentifier",
  "t_topologie2G_2".lac, 
  "t_topologie2G_2".ci, 
  "t_topologie2G_2"."AdministrativeState", 
  "t_topologie2G_2"."OperationalState", 
  "t_topologie2G_2"."AvailabilityStatus", 
  "t_topologie2G_2"."BCCHFrequency",
  "t_topologie2G_2"."HoppingSequenceNumber", 
  "t_topologie2G_2"."MobileAllocation"
   

FROM 
  public.t_topologie2g INNER JOIN public.t_topologie2g "t_topologie2G_2"
  ON 
	t_topologie2g."SiteID" = "t_topologie2G_2"."SiteID" AND
	t_topologie2g."codeOMC" = "t_topologie2G_2"."codeOMC" AND
	t_topologie2g."FrequencyRange" = "t_topologie2G_2"."FrequencyRange"  AND
	t_topologie2g."MobileAllocation" = "t_topologie2G_2"."MobileAllocation"
WHERE
  t_topologie2g."CellInstanceIdentifier" != "t_topologie2G_2"."CellInstanceIdentifier" AND
  t_topologie2g."HoppingSequenceNumber" != "t_topologie2G_2"."HoppingSequenceNumber"
ORDER BY
  t_topologie2g."CellName";
