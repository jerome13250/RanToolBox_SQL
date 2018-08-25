DROP TABLE IF EXISTS tmp_l2100_mappingfdd10fdd7;
CREATE TABLE tmp_l2100_mappingfdd10fdd7 AS
--Définit le mapping FDD10-FDD7:
SELECT 
  "WCEL1".name AS name_fdd10, 
  "WCEL1"."managedObject_WCEL" AS lcid_fdd10, 
  "WCEL2".name AS name_fdd7, 
  "WCEL2"."managedObject_WCEL" AS lcid_fdd7
FROM 
  public."nokia_WCEL" "WCEL1" INNER JOIN public."nokia_WCEL" "WCEL2"
  ON
  "WCEL1"."managedObject_distName_parent" = "WCEL2"."managedObject_distName_parent" AND
  "WCEL1"."SectorID" = "WCEL2"."SectorID"

WHERE
  "WCEL1"."UARFCN" = '10787'  AND
  "WCEL2"."UARFCN" = '10712'

UNION

SELECT 
  fddcell1.fddcell, 
  fddcell1.localcellid,
  fddcell2.fddcell, 
  fddcell2.localcellid
FROM 
  public.snap3g_fddcell fddcell1 INNER JOIN public.snap3g_fddcell fddcell2
  ON
    fddcell1.nodeb = fddcell2.nodeb
WHERE
  left(fddcell1.fddcell, -1)=left(fddcell2.fddcell, -1) AND
  fddcell1.dlfrequencynumber = '10787'  AND
  fddcell2.dlfrequencynumber = '10712'

ORDER BY 1
