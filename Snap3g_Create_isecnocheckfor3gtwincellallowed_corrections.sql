DROP TABLE IF EXISTS tmp_isecnocheckfor3gtwincellallowed_theorique;
CREATE TABLE tmp_isecnocheckfor3gtwincellallowed_theorique AS

SELECT 
  t1.nodeb,
  t1.fddcell,
  upper(substring(t1.fddcell from 1 for (char_length(t1.fddcell)-1))) AS sector_s, --upper car il y a des erreurs de nommage avec minuscules
  t1.dlfrequencynumber AS dlfrequencynumber_s,
  t1.localcellid, 
  t2.fddcell AS fddcell_v,
  upper(substring(t2.fddcell from 1 for (char_length(t2.fddcell)-1))) AS sector_v,
  t2.dlfrequencynumber AS dlfrequencynumber_v, 
  t2.cellid AS cellidv
FROM 
  public.t_topologie3g t1 LEFT JOIN public.t_topologie3g t2
  ON
    t1.nodeb = t2.nodeb
 WHERE 
   t1.nodeb IS NOT NULL AND
   t1.rnc != 'BACKUP_A';


DROP TABLE IF EXISTS t_isecnocheckfor3gtwincellallowed_theorique;
CREATE TABLE t_isecnocheckfor3gtwincellallowed_theorique AS

SELECT 
  fddcell,
  localcellid, 
  fddcell_v,
  cellidv
FROM 
  tmp_isecnocheckfor3gtwincellallowed_theorique
WHERE 
  sector_s = sector_v AND 
  fddcell != fddcell_v AND
  (
	(dlfrequencynumber_s ='10787' AND dlfrequencynumber_v ='10836') OR --FDD10 vers FDD12
	(dlfrequencynumber_s ='10812' AND dlfrequencynumber_v ='10787') OR --FDD11 vers FDD10
	(dlfrequencynumber_s ='10812' AND dlfrequencynumber_v ='10836') OR --FDD11 vers FDD12
	(dlfrequencynumber_s ='10836' AND dlfrequencynumber_v ='10787') OR --FDD12 vers FDD10
	(dlfrequencynumber_s ='10712' AND dlfrequencynumber_v ='10787') OR --FDD7 vers FDD10
	(dlfrequencynumber_s ='10712' AND dlfrequencynumber_v ='10836') --FDD7 vers FDD12
    
   )
  
	
  
ORDER BY
  fddcell ASC, 
  fddcell_v ASC;

  
--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_isecnocheckfor3gtwincellallowed_theorique;  
  

--Creation de la table terrain avec une ligne par cellid:
DROP TABLE IF EXISTS t_isecnocheckfor3gtwincellallowed_terrain;
CREATE TABLE t_isecnocheckfor3gtwincellallowed_terrain AS

SELECT 
    snap3g_fddcell.fddcell,
    snap3g_fddcell.localcellid,
    regexp_split_to_table(snap3g_fddcell.isecnocheckfor3gtwincellallowed, E'-') AS isecnocheckfor3gtwincellallowed
FROM   public.snap3g_fddcell
ORDER BY
  fddcell,
  isecnocheckfor3gtwincellallowed;

--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_isecnocheckfor3gtwincellallowed_terrain;

 -- Liste des problèmes:
DROP TABLE IF EXISTS t_isecnocheckfor3gtwincellallowed_errors;
CREATE TABLE t_isecnocheckfor3gtwincellallowed_errors AS

 SELECT DISTINCT
  t_isecnocheckfor3gtwincellallowed_theorique.fddcell, 
  t_isecnocheckfor3gtwincellallowed_theorique.localcellid,
  t_isecnocheckfor3gtwincellallowed_theorique.cellidv,
  'missing' AS error
FROM 
  public.t_isecnocheckfor3gtwincellallowed_theorique LEFT JOIN public.t_isecnocheckfor3gtwincellallowed_terrain
  ON 
  t_isecnocheckfor3gtwincellallowed_theorique.fddcell = t_isecnocheckfor3gtwincellallowed_terrain.fddcell AND
  t_isecnocheckfor3gtwincellallowed_theorique.cellidv = t_isecnocheckfor3gtwincellallowed_terrain.isecnocheckfor3gtwincellallowed
WHERE
  t_isecnocheckfor3gtwincellallowed_terrain.fddcell IS NULL


UNION

SELECT 
   t_isecnocheckfor3gtwincellallowed_terrain.fddcell,
   t_isecnocheckfor3gtwincellallowed_terrain.localcellid,
   t_isecnocheckfor3gtwincellallowed_terrain.isecnocheckfor3gtwincellallowed,
   'false' AS error

   
FROM 
  public.t_isecnocheckfor3gtwincellallowed_terrain LEFT JOIN public.t_isecnocheckfor3gtwincellallowed_theorique
  ON 
    t_isecnocheckfor3gtwincellallowed_terrain.fddcell = t_isecnocheckfor3gtwincellallowed_theorique.fddcell AND
    t_isecnocheckfor3gtwincellallowed_terrain.isecnocheckfor3gtwincellallowed = t_isecnocheckfor3gtwincellallowed_theorique.cellidv
WHERE 
  t_isecnocheckfor3gtwincellallowed_theorique.fddcell IS NULL
  AND isecnocheckfor3gtwincellallowed <> ''

ORDER BY
   fddcell, 
   cellidv;
   
   
--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_isecnocheckfor3gtwincellallowed_errors;


--creation table finale en prenant en compte l'activation du isecnocheckfor3gtwincellallowed
DROP TABLE IF EXISTS t_fddcell_list_generic_corrections;
CREATE TABLE t_fddcell_list_generic_corrections AS
SELECT DISTINCT
  t_topologie3g.rnc, 
  t_topologie3g.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid, 'Cluster/','') AS clusterid,
  t_topologie3g.nodeb, 
  t_topologie3g.fddcell,
  t_topologie3g.localcellid,
  t_isecnocheckfor3gtwincellallowed_theorique.cellidv AS param_value,
  'isEcNoCheckFor3GTwinCellAllowed'::text AS param_name 
FROM 
  public.t_isecnocheckfor3gtwincellallowed_errors, 
  public.t_isecnocheckfor3gtwincellallowed_theorique, 
  public.t_topologie3g, 
  public.snap3g_rnc
WHERE 
  t_isecnocheckfor3gtwincellallowed_theorique.fddcell = t_isecnocheckfor3gtwincellallowed_errors.fddcell AND
  t_isecnocheckfor3gtwincellallowed_theorique.fddcell = t_topologie3g.fddcell AND
  t_topologie3g.rnc = snap3g_rnc.rnc;
