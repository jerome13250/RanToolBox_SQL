DROP TABLE IF EXISTS t_twincelllist_theorique;
CREATE TABLE t_twincelllist_theorique AS

SELECT 
  t1.fddcell, 
  t1.localcellid, 
  t2.fddcell AS fddcell_v, 
  t2.cellid AS cellidv
FROM 
  public.t_topologie3g t1 INNER JOIN public.t_topologie3g t2
  ON
    t1.nodeb = t2.nodeb AND
    t1.sector_number = t2.sector_number
WHERE 
--upper car il y a des erreurs de nommage avec minuscules
  t1.fddcell != t2.fddcell AND
  t1.nodeb IS NOT NULL AND
  t1.rnc != 'BACKUP_A' AND
  t1.dlfrequencynumber IN ('10787','10812','10836','10712') AND
  t2.dlfrequencynumber IN ('10787','10812','10836','10712') AND
  upper(substring(t1.fddcell from 1 for (char_length(t1.fddcell)-1))) = upper(substring(t2.fddcell from 1 for (char_length(t2.fddcell)-1)))
  
ORDER BY
  t1.fddcell ASC, 
  t2.fddcell ASC;


--Ajout des cellules qui ne doivent pas avoir de twincell:
INSERT INTO t_twincelllist_theorique
SELECT 
  snap3g_fddcell.fddcell,
  snap3g_fddcell.localcellid,
  '' AS fddcell_v, 
  '' AS cellidv
FROM 
  public.snap3g_fddcell LEFT JOIN public.t_twincelllist_theorique
  ON
    snap3g_fddcell.fddcell = t_twincelllist_theorique.fddcell
WHERE 
  t_twincelllist_theorique.fddcell IS NULL AND
  snap3g_fddcell.rnc != 'BACKUP_A';


--Creation de la table terrain avec une ligne par cellid:
DROP TABLE IF EXISTS t_twincelllist_terrain;
CREATE TABLE t_twincelllist_terrain AS

SELECT 
    snap3g_fddcell.fddcell, 
    regexp_split_to_table(snap3g_fddcell.twincelllist, E'-') AS twincelllist
FROM   public.snap3g_fddcell
ORDER BY
  fddcell,
  twincelllist;


 -- Liste des problèmes:
DROP TABLE IF EXISTS t_twincelllist_errors;
CREATE TABLE t_twincelllist_errors AS

 SELECT DISTINCT
  t_twincelllist_theorique.fddcell, 
  t_twincelllist_theorique.cellidv,
  'missing' AS error
FROM 
  public.t_twincelllist_theorique LEFT JOIN public.t_twincelllist_terrain
  ON 
  t_twincelllist_theorique.fddcell = t_twincelllist_terrain.fddcell AND
  t_twincelllist_theorique.cellidv = t_twincelllist_terrain.twincelllist
WHERE
  t_twincelllist_terrain.fddcell IS NULL


UNION

SELECT 
   t_twincelllist_terrain.fddcell,
   t_twincelllist_terrain.twincelllist,
   'false' AS error

   
FROM 
  public.t_twincelllist_terrain LEFT JOIN public.t_twincelllist_theorique
  ON 
    t_twincelllist_terrain.fddcell = t_twincelllist_theorique.fddcell AND
    t_twincelllist_terrain.twincelllist = t_twincelllist_theorique.cellidv
WHERE 
  t_twincelllist_theorique.fddcell IS NULL
  AND twincelllist <> ''

ORDER BY
   fddcell, 
   cellidv;