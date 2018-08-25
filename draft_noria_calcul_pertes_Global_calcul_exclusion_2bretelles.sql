--Liste les cellules qui n'ont pas que des bretelles en equipement :
DROP TABLE IF EXISTS t_noria_pertes2200_otherthanbretelle_;
CREATE TABLE t_noria_pertes2200_otherthanbretelle AS

SELECT DISTINCT
  t_noria_pertes2200_calcul."ID_NORIA_CELL" 
FROM 
  public.t_noria_pertes2200_calcul
WHERE
  t_noria_pertes2200_calcul.object_type != 'installed3gbretelle';


DROP TABLE IF EXISTS t_noria_pertes2200_otherthanbretelle_;
CREATE TABLE t_noria_pertes2200_otherthanbretelle AS
SELECT 
  --t_noria_pertes2200."ID_CELL_SI", 
  t_noria_pertes2200."ID_NORIA_CELL" 
FROM 
  public.t_noria_pertes2200 LEFT JOIN t_noria_pertes2200_otherthanbretelle
ON 
  t_noria_pertes2200."ID_NORIA_CELL" = t_noria_pertes2200_otherthanbretelle."ID_NORIA_CELL"

WHERE
  t_noria_pertes2200.object_type = 'installed3gbretelle' AND
   t_noria_pertes2200_otherthanbretelle."ID_NORIA_CELL" IS NULL

GROUP BY
  t_noria_pertes2200."ID_CELL_SI", 
  t_noria_pertes2200."ID_NORIA_CELL"
HAVING 
  COUNT(t_noria_pertes2200."ID_CELL_SI")=2
;
