INSERT INTO t_topologie3g (rnc, rncid, fddcell,localcellid,cellid,locationareacode,codenidt)

SELECT DISTINCT
  'RESERVATION_TOPOplus'::text AS rnc, 
  '999999'::text AS rncid, 
  t_noria_topo_3g."NOM",
  t_topoplus_cellule_id_se."CONFIG_CEL_LCID", 
  t_topoplus_cellule_id_se."CONFIG_CEL_CID", 
  '999999'::text AS locationareacode,
  t_noria_topo_3g."GN"
  --t_noria_topo_3g."ETAT_DEPL",
  --t_noria_topo_3g."ETAT_FONCT"
FROM 
  public.t_topoplus_cellule_id_se LEFT JOIN public.t_topologie3g 
  ON
	t_topoplus_cellule_id_se."CONFIG_CEL_LCID" = t_topologie3g.localcellid
  LEFT JOIN public.t_noria_topo_3g
  ON
	t_topoplus_cellule_id_se."CONFIG_CEL_LCID" = t_noria_topo_3g."IDRESEAUCELLULE"
WHERE 
  t_topologie3g.localcellid IS NULL AND --lcid n'existent pas dans les OMCs => ce sont les seuls a prendre en compte
  t_topoplus_cellule_id_se."CONFIG_CEL_CID" != '0' AND--réservations cid=0 incohérentes
  t_noria_topo_3g."ETAT_DEPL" NOT LIKE 'DISMANTL%' AND --Pas demonté
  t_noria_topo_3g."ETAT_FONCT" != 'SWITCHED_OFF' -- Pas éteint */
ORDER BY
  t_noria_topo_3g."NOM"
  ;
