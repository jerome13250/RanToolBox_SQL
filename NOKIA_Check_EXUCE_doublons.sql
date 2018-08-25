--Sert a trouver les exuce en doublon:
SELECT 
  exuce1."managedObject_EXUCE" AS "managedObject_EXUCE1", 
  exuce1."name", 
  exuce1."cId", 
  exuce1."rncId", 
  exuce1.mnc, 
  exuce1.mcc, 
  exuce2."managedObject_EXUCE",
  exuce2."name"
FROM 
  public."nokia_EXUCE" exuce1
  
  INNER JOIN public."nokia_EXUCE" exuce2
  ON --Les EXUCE ont les mêmes cId, rncId, mcc, mnc
	exuce1."cId" = exuce2."cId" AND
	exuce1.mcc = exuce2.mcc AND
	exuce1.mnc = exuce2.mnc AND
	exuce1."rncId" = exuce2."rncId"
  
WHERE
  exuce1."managedObject_distName" != exuce2."managedObject_distName" --les EXUCE sont différents
ORDER BY
  exuce1."cId"::int

;