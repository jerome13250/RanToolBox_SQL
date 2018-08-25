DROP TABLE IF EXISTS t_fddcell_list_generic_corrections;
CREATE TABLE t_fddcell_list_generic_corrections AS

SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.provisionedsystemrelease, 
  replace(snap3g_rnc.clusterid, 'Cluster/', '') as clusterid,
  t_topologie3g.nodeb,
  t_twincelllist_theorique.fddcell, 
  t_twincelllist_theorique.cellidv as param_value
FROM 
  public.t_twincelllist_theorique INNER JOIN public.t_topologie3g
  ON
	t_twincelllist_theorique.fddcell = t_topologie3g.fddcell
  INNER JOIN public.snap3g_rnc
  ON
	t_topologie3g.rnc = snap3g_rnc.rnc
WHERE 
  t_twincelllist_theorique.fddcell IN 
  (
  SELECT DISTINCT 
	t_twincelllist_errors.fddcell
	FROM t_twincelllist_errors
  )

ORDER BY
  t_topologie3g.rnc ASC,
  t_topologie3g.nodeb,
  t_twincelllist_theorique.fddcell ASC;

--Creation de la colonne contenant le nom du parametre:
ALTER TABLE t_fddcell_list_generic_corrections ADD COLUMN param_name text DEFAULT 'twinCellList';
