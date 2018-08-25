SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.runningsoftwareversion, 
  t_topologie3g.fddcell, 
  t_topologie3g.cellid, 
  t_topologie3g.alcatel_cellcode_ct, 
  t_topologie3g.dlfrequencynumber, 
  t_topologie3g.localcellid, 
  t_topologie3g.primaryscramblingcode, 
  t_topologie3g.mobilecountrycode, 
  t_topologie3g.mobilenetworkcode, 
  t_topologie3g.administrativestate, 
  t_topologie3g.operationalstate, 
  t_topologie3g.availabilitystatus, 
  bdref_t_topologie."Classe"
FROM 
  public.t_topologie3g INNER JOIN public.bdref_t_topologie
  ON 
    t_topologie3g.localcellid = bdref_t_topologie."LCID"
  LEFT JOIN public.t_mapping_bdref3gclasse_freq_max 
  ON
    t_topologie3g.dlfrequencynumber = t_mapping_bdref3gclasse_freq_max.dlfrequencynumber AND
    bdref_t_topologie."Classe" = t_mapping_bdref3gclasse_freq_max."Classe"
WHERE
  t_mapping_bdref3gclasse_freq_max."Classe" IS NULL
ORDER BY
  t_topologie3g.fddcell;
