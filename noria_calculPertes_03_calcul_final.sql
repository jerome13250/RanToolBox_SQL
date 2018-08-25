--Lancement du calcul sur les cables et bretelles :
DROP TABLE IF EXISTS t_noria_pertes2200_calcul_resultats;
CREATE TABLE t_noria_pertes2200_calcul_resultats AS

SELECT 
  t_noria_pertes2200_calcul."ID_CELL_SI", 
  t_noria_pertes2200_calcul."ID_NORIA_CELL", 
  string_agg(t_noria_pertes2200_calcul.object_type || ':' || t_noria_pertes2200_calcul.info_pertes,'*') AS info_pertes, 
  round(SUM(t_noria_pertes2200_calcul.pertes_2200),2) AS pertes_totales
FROM 
  public.t_noria_pertes2200_calcul
--WHERE
  --"ID_CELL_SI" LIKE '%J4%'
GROUP BY
  t_noria_pertes2200_calcul."ID_CELL_SI", 
  t_noria_pertes2200_calcul."ID_NORIA_CELL"
ORDER BY
   "ID_CELL_SI"; 
