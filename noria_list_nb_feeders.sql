SELECT 
 nbcable,
 count(nbcable)
FROM (
SELECT 
  noria_installed3gcable."ID_CELL_SI", 
  noria_installed3gcable."ID_NORIA_CELL",
  COUNT(noria_installed3gcable."ID_CELL_SI") AS nbcable
FROM 
  public.noria_installed3gcable
WHERE
  noria_installed3gcable."ID_CELL_SI" LIKE '%J%' OR
  noria_installed3gcable."ID_CELL_SI" LIKE '%H%' OR
  noria_installed3gcable."ID_CELL_SI" LIKE '%V%'

GROUP BY
  noria_installed3gcable."ID_CELL_SI", 
  noria_installed3gcable."ID_NORIA_CELL"
ORDER BY
  noria_installed3gcable."ID_CELL_SI") AS t1
GROUP BY
  nbcable
ORDER BY
  nbcable
;
