SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.runningsoftwareversion, 
  t_topologie3g.fddcell, 
  t_topologie3g.cellid, 
  t_topologie3g.dlfrequencynumber, 
  t_topologie3g.localcellid, 
  t_topologie3g.mobilecountrycode, 
  t_topologie3g.mobilenetworkcode, 
  t_topologie3g.administrativestate, 
  t_topologie3g.operationalstate, 
  t_topologie3g.availabilitystatus, 
  --bdref_t_topologie."NOM SITE", 
  bdref_t_topologie."NIDT", 
  bdref_t_topologie."NOEUD", 
  bdref_t_topologie."LCID", 
  --bdref_t_topologie."CID", 
  bdref_t_topologie."NOM",
  bdref_t_topologie."Classe"
FROM 
  public.t_topologie3g LEFT JOIN public.bdref_t_topologie
  ON 
    t_topologie3g.localcellid = bdref_t_topologie."LCID"
  WHERE
    t_topologie3g.fddcell != bdref_t_topologie."NOM"
    OR (bdref_t_topologie."LCID" IS NULL
        AND t_topologie3g.rnc != 'EXTERNAL')
ORDER BY
  t_topologie3g.fddcell;
