--permet de trouver les SectorId faux
DROP TABLE IF EXISTS t_allObjects_generic_corrections;
CREATE TABLE t_allObjects_generic_corrections AS
SELECT 
  "nokia_WCEL"."managedObject_version", 
  "nokia_WCEL"."managedObject_id", 
  "nokia_WCEL"."managedObject_distName", 
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL".name,
  'WCEL'::text AS object_class, 
  "nokia_WCEL"."SectorID" AS "old_SectorID",
  'SectorID'::text AS param_name,
  left(right(replace("nokia_WCEL".name,' ',''),2),1) AS param_value --replace des espaces car qques erreurs dans les noms de cellules
FROM 
  public."nokia_WCEL"
WHERE
  left(right(replace("nokia_WCEL".name,' ',''),2),1) != "nokia_WCEL"."SectorID";
