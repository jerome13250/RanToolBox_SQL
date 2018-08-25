DROP TABLE IF EXISTS t_mapping_bdref3gclasse_freq;

CREATE TABLE t_mapping_bdref3gclasse_freq AS
SELECT 
  bdref_t_topologie."Classe",
  t_topologie3g.dlfrequencynumber, 
  COUNT(t_topologie3g.dlfrequencynumber) AS number_cell
FROM 
  public.t_topologie3g JOIN public.bdref_t_topologie
  ON  
	t_topologie3g.localcellid = bdref_t_topologie."LCID"
--WHERE 
  --t_topologie3g.rnc != 'EXTERNAL'
GROUP BY 
  t_topologie3g.dlfrequencynumber, 
  bdref_t_topologie."Classe"
ORDER BY 
   bdref_t_topologie."Classe",
  number_cell DESC;


--ON trouve la valeur max pour chaque Classe:  
DROP TABLE IF EXISTS t_mapping_bdref3gclasse_freq_tmp;

CREATE TABLE t_mapping_bdref3gclasse_freq_tmp AS
SELECT 
  t_mapping_bdref3gclasse_freq."Classe", 
  MAX(t_mapping_bdref3gclasse_freq.number_cell)
FROM 
  public.t_mapping_bdref3gclasse_freq
GROUP BY
  t_mapping_bdref3gclasse_freq."Classe";


--ON retrouve la frequence la plus courante pour chaque Classe:  
DROP TABLE IF EXISTS t_mapping_bdref3gclasse_freq_max;

CREATE TABLE t_mapping_bdref3gclasse_freq_max AS
SELECT 
  t_mapping_bdref3gclasse_freq."Classe", 
  t_mapping_bdref3gclasse_freq.dlfrequencynumber, 
  t_mapping_bdref3gclasse_freq.number_cell
FROM 
  public.t_mapping_bdref3gclasse_freq, 
  public.t_mapping_bdref3gclasse_freq_tmp
WHERE 
  t_mapping_bdref3gclasse_freq."Classe" = t_mapping_bdref3gclasse_freq_tmp."Classe" AND
  t_mapping_bdref3gclasse_freq.number_cell = t_mapping_bdref3gclasse_freq_tmp.max
ORDER BY
  t_mapping_bdref3gclasse_freq.dlfrequencynumber,
  t_mapping_bdref3gclasse_freq."Classe";


--Suppression des 2 tables originales:
DROP TABLE IF EXISTS t_mapping_bdref3gclasse_freq_tmp;
DROP TABLE IF EXISTS t_mapping_bdref3gclasse_freq;