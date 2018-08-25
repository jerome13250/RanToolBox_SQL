--Lancement du calcul sur les cables et bretelles :
DROP TABLE IF EXISTS t_noria_pertes2200_calcul;
CREATE TABLE t_noria_pertes2200_calcul AS

SELECT 
  "ID_CELL_SI", 
  "ID_NORIA_CELL", 
  object_type, 
  string_agg("VALEUR|$|",'/') AS info_pertes, 
  sum(numeric_value)/2 AS pertes_2200  --Somme des pertes /2 car on a deux voix.
FROM 
  public.t_noria_pertes2200_listmateriel
WHERE
  object_type IN ('installed3gcable','installed3gbretelle')

GROUP BY
  "ID_CELL_SI", 
  "ID_NORIA_CELL",  
  object_type 
ORDER BY 
  "ID_CELL_SI";

--On recherche tous les objets qui n'ont pas 2 cables
--A noter que ça ne permet pas de trouver les cellules qui n'ont aucun cable
DROP TABLE IF EXISTS t_noria_not2cables;
CREATE TABLE t_noria_not2cables AS

SELECT
  noria_installed3gcable."ID_CELL_SI", 
  noria_installed3gcable."ID_NORIA_CELL",
  COUNT(noria_installed3gcable."ID_CELL_SI") AS nb_cable
FROM 
  public.noria_installed3gcable
GROUP BY 
  noria_installed3gcable."ID_CELL_SI", 
  noria_installed3gcable."ID_NORIA_CELL"
HAVING
  COUNT(noria_installed3gcable."ID_CELL_SI") != 2;

--On passe à NaN toutes les configs dont le nombre de cable != 2
UPDATE t_noria_pertes2200_calcul 
SET 
	pertes_2200 ='NaN'::numeric,
	info_pertes = info_pertes || ' !!!nb cable != 2 !!!'
FROM t_noria_not2cables
WHERE 
	t_noria_pertes2200_calcul."ID_CELL_SI" = t_noria_not2cables."ID_CELL_SI" AND
	t_noria_pertes2200_calcul."ID_NORIA_CELL" = t_noria_not2cables."ID_NORIA_CELL"  AND
	object_type = 'installed3gcable';

--On rajoute une ligne avec une valeur NaN pour toutes les configs qui n'ont pas de cable du tout:
--Il faut exclure les sites RRH avec seulement 2 bretelles...

-- A FAIRE !!!!


--On rajoute tout ce qui n'est pas cable et bretelle dans le calcul:
INSERT INTO t_noria_pertes2200_calcul

SELECT 
  "ID_CELL_SI", 
  "ID_NORIA_CELL", 
  object_type, 
  "VALEUR|$|", 
  numeric_value
FROM t_noria_pertes2200_listmateriel
WHERE 
  object_type NOT IN ('installed3gcable','installed3gbretelle');
  




