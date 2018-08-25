--Modifications supplémentaires paramètres HOTSPOT :

--Vérification du DCellHSDPACapaHO
SELECT 
  bdref_visutoporef_cell_nokia."CLASSE", 
  bdref_visutoporef_cell_nokia."NIDT", 
  bdref_visutoporef_cell_nokia."LCID", 
  bdref_visutoporef_cell_nokia."NOM", 
  bdref_visutoporef_cell_nokia."Etat", 
  bdref_visutoporef_cell_nokia."HotSpot",
  "nokia_WCEL"."UARFCN", 
  --"CellWeightForHSDPALayering",
  "DCellHSDPACapaHO" AS rollback_valeur,
  'DCellHSDPACapaHO'::text AS parametre,
  0 AS valeur,
  'param complémentaire HotSpot'::text AS commentaire
FROM 
  public.bdref_visutoporef_cell_nokia INNER JOIN public."nokia_WCEL"
  ON 
    bdref_visutoporef_cell_nokia."LCID" = "nokia_WCEL"."managedObject_WCEL"
WHERE
  bdref_visutoporef_cell_nokia."HotSpot" = 'HotSpot' AND
  --(("nokia_WCEL"."UARFCN" = '10712' AND "CellWeightForHSDPALayering" != '100') OR
  "nokia_WCEL"."DCellHSDPACapaHO" = '1'

UNION --Vérification du CellWeightForHSDPALayering

SELECT 
  bdref_visutoporef_cell_nokia."CLASSE", 
  bdref_visutoporef_cell_nokia."NIDT", 
  bdref_visutoporef_cell_nokia."LCID", 
  bdref_visutoporef_cell_nokia."NOM", 
  bdref_visutoporef_cell_nokia."Etat", 
  bdref_visutoporef_cell_nokia."HotSpot",
  "nokia_WCEL"."UARFCN", 
  "CellWeightForHSDPALayering" AS rollback_valeur,
  'CellWeightForHSDPALayering'::text AS parametre,
  100 AS valeur,
  'param complementaire HotSpot'::text AS commentaire
FROM 
  public.bdref_visutoporef_cell_nokia INNER JOIN public."nokia_WCEL"
  ON 
    bdref_visutoporef_cell_nokia."LCID" = "nokia_WCEL"."managedObject_WCEL"
WHERE
  bdref_visutoporef_cell_nokia."HotSpot" = 'HotSpot' AND
  ("nokia_WCEL"."UARFCN" = '10712' AND "CellWeightForHSDPALayering" != '100')

ORDER BY 
    "NOM";
