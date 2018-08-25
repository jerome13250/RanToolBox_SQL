DROP TABLE IF EXISTS t_allObjects_generic_corrections;
CREATE TABLE t_allObjects_generic_corrections AS

/*
--1:Erreur de nom:
SELECT 
  "nokia_EXUCE"."managedObject_version",
  "nokia_EXUCE"."managedObject_id",
  "nokia_EXUCE"."managedObject_distName",
  "nokia_EXUCE"."managedObject_distName_parent",
  "nokia_EXUCE"."managedObject_EXUCE",
  'EXUCE'::text AS object_class,
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  "nokia_EXUCE".name AS old_valeur,
  'name'::text AS param_name,
  t_topologie3g.fddcell AS param_value

FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g
  ON 
	"nokia_EXUCE"."rncId" = t_topologie3g.rncid AND
	"nokia_EXUCE"."cId" = t_topologie3g.cellid AND
	"nokia_EXUCE"."mnc" = t_topologie3g.mobilenetworkcode AND
	"nokia_EXUCE"."mcc" = t_topologie3g.mobilecountrycode
  LEFT JOIN t_allObjects_generic_delete --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  ON
        "nokia_EXUCE"."managedObject_distName" = t_allObjects_generic_delete."managedObject_distName"
WHERE
  t_topologie3g.nodeb IS NOT NULL AND --Cellule interne ALU
  t_allObjects_generic_delete."managedObject_distName" IS NULL --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  AND (
  "nokia_EXUCE".name != t_topologie3g.fddcell 
  OR "nokia_EXUCE".name IS NULL
  )

UNION
*/

--2:Erreur de dlfrequencynumber:
SELECT 
  "nokia_EXUCE"."managedObject_version",
  "nokia_EXUCE"."managedObject_id",
  "nokia_EXUCE"."managedObject_distName",
  "nokia_EXUCE"."managedObject_distName_parent",
  "nokia_EXUCE"."managedObject_EXUCE",
  'EXUCE'::text AS object_class,
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  "nokia_EXUCE"."uarfcnDl" AS old_valeur,
  'uarfcnDl'::text AS param_name,
  t_topologie3g.dlfrequencynumber AS param_value

  
FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g
  ON 
	"nokia_EXUCE"."rncId" = t_topologie3g.rncid AND
	"nokia_EXUCE"."cId" = t_topologie3g.cellid AND
	"nokia_EXUCE"."mnc" = t_topologie3g.mobilenetworkcode AND
	"nokia_EXUCE"."mcc" = t_topologie3g.mobilecountrycode
LEFT JOIN t_allObjects_generic_delete --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  ON
        "nokia_EXUCE"."managedObject_distName" = t_allObjects_generic_delete."managedObject_distName"
WHERE
  t_topologie3g.nodeb IS NOT NULL AND --Cellule interne ALU
  t_allObjects_generic_delete."managedObject_distName" IS NULL --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  AND (
  "nokia_EXUCE"."uarfcnDl" != t_topologie3g.dlfrequencynumber 
  OR "nokia_EXUCE"."uarfcnDl" IS NULL
  )
 
UNION

/*
--3:Erreur de ulfrequencynumber:
SELECT 
  "nokia_EXUCE"."managedObject_version",
  "nokia_EXUCE"."managedObject_id",
  "nokia_EXUCE"."managedObject_distName",
  "nokia_EXUCE"."managedObject_distName_parent",
  "nokia_EXUCE"."managedObject_EXUCE",
  'EXUCE'::text AS object_class,
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  "nokia_EXUCE"."uarfcnUl" AS old_valeur,
  'uarfcnUl'::text AS param_name,
  t_topologie3g.ulfrequencynumber AS param_value

  
FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g
  ON 
	"nokia_EXUCE"."rncId" = t_topologie3g.rncid AND
	"nokia_EXUCE"."cId" = t_topologie3g.cellid AND
	"nokia_EXUCE"."mnc" = t_topologie3g.mobilenetworkcode AND
	"nokia_EXUCE"."mcc" = t_topologie3g.mobilecountrycode
LEFT JOIN t_allObjects_generic_delete --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  ON
        "nokia_EXUCE"."managedObject_distName" = t_allObjects_generic_delete."managedObject_distName"
WHERE
  t_topologie3g.nodeb IS NOT NULL AND --Cellule interne ALU
  t_allObjects_generic_delete."managedObject_distName" IS NULL --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  AND (
  "nokia_EXUCE"."uarfcnUl" != t_topologie3g.ulfrequencynumber 
  --OR "nokia_EXUCE"."uarfcnUl" IS NULL
  )
 
UNION

*/

--Erreur de locationareacode:
SELECT 
  "nokia_EXUCE"."managedObject_version",
  "nokia_EXUCE"."managedObject_id",
  "nokia_EXUCE"."managedObject_distName",
  "nokia_EXUCE"."managedObject_distName_parent",
  "nokia_EXUCE"."managedObject_EXUCE",
  'EXUCE'::text AS object_class,
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  "nokia_EXUCE".lac AS old_valeur,
  'lac'::text AS param_name,
  t_topologie3g.locationareacode AS param_value

FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g
  ON 
	"nokia_EXUCE"."rncId" = t_topologie3g.rncid AND
	"nokia_EXUCE"."cId" = t_topologie3g.cellid AND
	"nokia_EXUCE"."mnc" = t_topologie3g.mobilenetworkcode AND
	"nokia_EXUCE"."mcc" = t_topologie3g.mobilecountrycode
  LEFT JOIN t_allObjects_generic_delete --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  ON
        "nokia_EXUCE"."managedObject_distName" = t_allObjects_generic_delete."managedObject_distName"
WHERE
  t_topologie3g.nodeb IS NOT NULL AND --Cellule interne ALU
  t_allObjects_generic_delete."managedObject_distName" IS NULL --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  AND (
  "nokia_EXUCE".lac != t_topologie3g.locationareacode 
  OR "nokia_EXUCE".lac IS NULL
  )

UNION

/*
--Erreur de serviceareacode:
SELECT 
  "nokia_EXUCE"."managedObject_version",
  "nokia_EXUCE"."managedObject_id",
  "nokia_EXUCE"."managedObject_distName",
  "nokia_EXUCE"."managedObject_distName_parent",
  "nokia_EXUCE"."managedObject_EXUCE",
  'EXUCE'::text AS object_class,
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  "nokia_EXUCE".sac AS old_valeur,
  'sac'::text AS param_name,
  t_topologie3g.serviceareacode AS param_value

FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g
  ON 
	"nokia_EXUCE"."rncId" = t_topologie3g.rncid AND
	"nokia_EXUCE"."cId" = t_topologie3g.cellid AND
	"nokia_EXUCE"."mnc" = t_topologie3g.mobilenetworkcode AND
	"nokia_EXUCE"."mcc" = t_topologie3g.mobilecountrycode
  LEFT JOIN t_allObjects_generic_delete --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  ON
        "nokia_EXUCE"."managedObject_distName" = t_allObjects_generic_delete."managedObject_distName"
WHERE
  t_topologie3g.nodeb IS NOT NULL AND --Cellule interne ALU
  t_allObjects_generic_delete."managedObject_distName" IS NULL --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  AND (
  "nokia_EXUCE".sac != t_topologie3g.serviceareacode 
  OR "nokia_EXUCE".sac IS NULL
  )

UNION
*/
--Erreur de primaryscramblingcode:
SELECT 
  "nokia_EXUCE"."managedObject_version",
  "nokia_EXUCE"."managedObject_id",
  "nokia_EXUCE"."managedObject_distName",
  "nokia_EXUCE"."managedObject_distName_parent",
  "nokia_EXUCE"."managedObject_EXUCE",
  'EXUCE'::text AS object_class,
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  "nokia_EXUCE"."primScrmCode" AS old_valeur,
  'primScrmCode'::text AS param_name,
  t_topologie3g.primaryscramblingcode AS param_value

FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g
  ON 
	"nokia_EXUCE"."rncId" = t_topologie3g.rncid AND
	"nokia_EXUCE"."cId" = t_topologie3g.cellid AND
	"nokia_EXUCE"."mnc" = t_topologie3g.mobilenetworkcode AND
	"nokia_EXUCE"."mcc" = t_topologie3g.mobilecountrycode
  LEFT JOIN t_allObjects_generic_delete --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  ON
        "nokia_EXUCE"."managedObject_distName" = t_allObjects_generic_delete."managedObject_distName"
WHERE
  t_topologie3g.nodeb IS NOT NULL AND --Cellule interne ALU
  t_allObjects_generic_delete."managedObject_distName" IS NULL --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  AND (
  "nokia_EXUCE"."primScrmCode" != t_topologie3g.primaryscramblingcode 
  OR "nokia_EXUCE"."primScrmCode" IS NULL
  )

UNION

--Erreur de routingareacode:
SELECT 
  "nokia_EXUCE"."managedObject_version",
  "nokia_EXUCE"."managedObject_id",
  "nokia_EXUCE"."managedObject_distName",
  "nokia_EXUCE"."managedObject_distName_parent",
  "nokia_EXUCE"."managedObject_EXUCE",
  'EXUCE'::text AS object_class,
  "nokia_EXUCE".name,
  "nokia_EXUCE"."rncId",
  "nokia_EXUCE"."cId",
  "nokia_EXUCE".rac AS old_valeur,
  'rac'::text AS param_name,
  t_topologie3g.routingareacode AS param_value

FROM 
  public."nokia_EXUCE" LEFT JOIN public.t_topologie3g
  ON 
	"nokia_EXUCE"."rncId" = t_topologie3g.rncid AND
	"nokia_EXUCE"."cId" = t_topologie3g.cellid AND
	"nokia_EXUCE"."mnc" = t_topologie3g.mobilenetworkcode AND
	"nokia_EXUCE"."mcc" = t_topologie3g.mobilecountrycode
LEFT JOIN t_allObjects_generic_delete --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  ON
        "nokia_EXUCE"."managedObject_distName" = t_allObjects_generic_delete."managedObject_distName"
WHERE
  t_topologie3g.nodeb IS NOT NULL AND --Cellule interne ALU
  t_allObjects_generic_delete."managedObject_distName" IS NULL --permet de ne pas demander de modification sur des exuce qui doivent être détruits
  AND (
  "nokia_EXUCE".rac != t_topologie3g.routingareacode   
  OR "nokia_EXUCE".rac IS NULL
  )

ORDER BY param_name;
