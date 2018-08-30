--Cette requete sert a trouver la liste des EXUCE inutiles car aucune voisine ne pointe dessus avec "TargetCelldn"
SELECT 
  "nokia_EXUCE"."managedObject_version", 
  "nokia_EXUCE"."managedObject_id", 
  "nokia_EXUCE"."managedObject_distName", 
  "nokia_EXUCE"."managedObject_distName_parent", 
  "nokia_EXUCE"."managedObject_EXUCE",
  "nokia_EXUCE".name
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
WHERE
   "nokia_ADJS"."managedObject_distName" IS NULL AND
   "nokia_ADJI"."managedObject_distName" IS NULL AND
   "nokia_ADJW"."managedObject_distName" IS NULL AND
   "nokia_LNRELW"."managedObject_distName" IS NULL
ORDER BY
  "nokia_EXUCE"."managedObject_distName"
  ;
