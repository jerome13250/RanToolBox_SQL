DROP TABLE IF EXISTS t_allObjects_generic_delete;
CREATE TABLE t_allObjects_generic_delete AS

SELECT
  "nokia_EXUCE"."managedObject_version", 
  "nokia_EXUCE"."managedObject_id", 
  "nokia_EXUCE"."managedObject_distName", 
  "nokia_EXUCE"."managedObject_distName_parent", 
  "nokia_EXUCE"."managedObject_EXUCE",
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  'EXUCE'::text AS object_class
FROM 
  public."nokia_EXUCE" LEFT JOIN public."nokia_ADJS"
  ON
	"nokia_ADJS"."TargetCellDN" = "nokia_EXUCE"."managedObject_distName"
  LEFT JOIN  public."nokia_ADJI"
  ON
	"nokia_ADJI"."TargetCellDN" = "nokia_EXUCE"."managedObject_distName"
  LEFT JOIN  public."nokia_ADJW"
  ON
	"nokia_ADJW"."targetCellDN" = "nokia_EXUCE"."managedObject_distName"
  LEFT JOIN public."nokia_LNRELW"
  ON
	"nokia_LNRELW"."targetCellDn" = "nokia_EXUCE"."managedObject_distName"
  LEFT JOIN public."nokia_LNADJW"
  ON
	"nokia_LNADJW"."targetCellDn" = "nokia_EXUCE"."managedObject_distName"
WHERE
   "nokia_ADJS"."managedObject_distName" IS NULL AND
   "nokia_ADJI"."managedObject_distName" IS NULL AND
   "nokia_ADJW"."managedObject_distName" IS NULL AND
   "nokia_LNRELW"."managedObject_distName" IS NULL AND
   "nokia_LNADJW"."managedObject_distName" IS NULL
ORDER BY 
  "nokia_EXUCE"."managedObject_distName"
  ;
