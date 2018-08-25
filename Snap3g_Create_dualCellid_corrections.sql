DROP TABLE IF EXISTS tmp_dualcellid_theorique;
CREATE TABLE tmp_dualcellid_theorique AS

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


DROP TABLE IF EXISTS t_dualcellid_theorique;
CREATE TABLE t_dualcellid_theorique AS

SELECT 
  fddcell,
  localcellid, 
  fddcell_v,
  cellidv
FROM 
  tmp_dualcellid_theorique
WHERE 
  sector_s = sector_v AND 
  fddcell != fddcell_v AND
  (
   (
    ((dlfrequencynumber_s ='10787' AND dlfrequencynumber_v ='10812') OR (dlfrequencynumber_s ='10812' AND dlfrequencynumber_v ='10787')) AND
    nodeb NOT IN (SELECT DISTINCT snap3g_fddcell.nodeb  --On n'est pas dans un nodeB qui contient du FDD12 donc DC sur 10 et 11
			FROM public.snap3g_fddcell
			WHERE snap3g_fddcell.dlfrequencynumber='10836')
   )
   OR
   (
    ((dlfrequencynumber_s ='10812' AND dlfrequencynumber_v ='10836') OR (dlfrequencynumber_s ='10836' AND dlfrequencynumber_v ='10812')) AND
    nodeb IN (SELECT DISTINCT snap3g_fddcell.nodeb  --On est dans un nodeB qui contient du FDD12 donc DC sur 11 et 12
			FROM public.snap3g_fddcell
			WHERE snap3g_fddcell.dlfrequencynumber='10836')
   
    )
   )
  
	
  
ORDER BY
  fddcell ASC, 
  fddcell_v ASC;

  
--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_dualcellid_theorique;  
  

--Ajout des cellules qui ne doivent pas avoir de dualcell:
INSERT INTO t_dualcellid_theorique
SELECT 
  snap3g_fddcell.fddcell,
  snap3g_fddcell.localcellid,
  '' AS fddcell_v, 
  '' AS cellidv
FROM 
  public.snap3g_fddcell LEFT JOIN public.t_dualcellid_theorique
  ON
    snap3g_fddcell.fddcell = t_dualcellid_theorique.fddcell
WHERE 
  t_dualcellid_theorique.fddcell IS NULL;

--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_dualcellid_theorique;  

--Creation de la table terrain avec une ligne par cellid:
DROP TABLE IF EXISTS t_dualcellid_terrain;
CREATE TABLE t_dualcellid_terrain AS

SELECT 
    snap3g_fddcell.fddcell, 
    regexp_split_to_table(snap3g_fddcell.dualcellid, E'-') AS dualcellid
FROM   public.snap3g_fddcell
ORDER BY
  fddcell,
  dualcellid;

--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_dualcellid_terrain;

 -- Liste des problèmes:
DROP TABLE IF EXISTS t_dualcellid_errors;
CREATE TABLE t_dualcellid_errors AS

 SELECT DISTINCT
  t_dualcellid_theorique.fddcell, 
  t_dualcellid_theorique.cellidv,
  'missing' AS error
FROM 
  public.t_dualcellid_theorique LEFT JOIN public.t_dualcellid_terrain
  ON 
  t_dualcellid_theorique.fddcell = t_dualcellid_terrain.fddcell AND
  t_dualcellid_theorique.cellidv = t_dualcellid_terrain.dualcellid
WHERE
  t_dualcellid_terrain.fddcell IS NULL


UNION

SELECT 
   t_dualcellid_terrain.fddcell,
   t_dualcellid_terrain.dualcellid,
   'false' AS error

   
FROM 
  public.t_dualcellid_terrain LEFT JOIN public.t_dualcellid_theorique
  ON 
    t_dualcellid_terrain.fddcell = t_dualcellid_theorique.fddcell AND
    t_dualcellid_terrain.dualcellid = t_dualcellid_theorique.cellidv
WHERE 
  t_dualcellid_theorique.fddcell IS NULL
  AND dualcellid <> ''

ORDER BY
   fddcell, 
   cellidv;
   
   
--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_dualcellid_errors;


--creation table finale en prenant en compte l'activation du dualcellid
DROP TABLE IF EXISTS t_dualcellid_errors_final;
CREATE TABLE t_dualcellid_errors_final AS

SELECT 
  t_dualcellid_errors.fddcell, 
  snap3g_fddcell.ishsdpadualcellactivated, 
  t_dualcellid_errors.cellidv, 
  t_dualcellid_errors.error
FROM 
  public.t_dualcellid_errors INNER JOIN public.snap3g_fddcell
  ON
	t_dualcellid_errors.fddcell = snap3g_fddcell.fddcell
WHERE

	--localcellid IN ('232024','232027','232025','232028','232026','232029','233254','233257','233255','233258','245813',
	--'245815','245814','245816','246444','246447','246445','246448','246446','246449','213374','213377','213375','213378',
	--'213376','213379','226654','226657','226655','26658','226656','226659','213304','213307','213305','213308','213306',
	--'213309','291773','291775','291774','291776','235494','235497','235495','235498','235496','235499','200614','200617',
	--'200615','200618','200616','200619','220204','810714','220205','810715','220206','810716','243484','243487','243485',
	--'243488','243486','243489','202934','202937','202935','202938','202936','202939')

	NOT(ishsdpadualcellactivated = 'false' AND error = 'missing')
  ;

  
--Analyze de la table car il y a une lenteur d'exécution dans java
ANALYZE t_dualcellid_errors_final;

--creation table finale en prenant en compte l'activation du dualcellid
DROP TABLE IF EXISTS t_fddcell_list_generic_corrections;
CREATE TABLE t_fddcell_list_generic_corrections AS
SELECT DISTINCT
  t_topologie3g.rnc, 
  t_topologie3g.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid, 'Cluster/','') AS clusterid,
  t_topologie3g.nodeb, 
  t_topologie3g.fddcell,
  t_dualcellid_theorique.cellidv AS param_value,
  'dualCellId'::text AS param_name 
FROM 
  public.t_dualcellid_errors_final, 
  public.t_dualcellid_theorique, 
  public.t_topologie3g, 
  public.snap3g_rnc
WHERE 
  t_dualcellid_theorique.fddcell = t_dualcellid_errors_final.fddcell AND
  t_dualcellid_theorique.fddcell = t_topologie3g.fddcell AND
  t_topologie3g.rnc = snap3g_rnc.rnc;
