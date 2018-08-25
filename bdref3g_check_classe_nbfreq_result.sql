SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.fddcell, 
  tmp_nodeb_nbfreq2100orange.nbfreq2100orange, 
  t_topologie3g.dlfrequencynumber, 
  t_topologie3g.localcellid, 
  bdref_t_topologie."Classe"
FROM 
  tmp_nodeb_nbfreq2100orange INNER JOIN t_topologie3g
  ON 
     tmp_nodeb_nbfreq2100orange.nodeb = t_topologie3g.nodeb
  INNER JOIN public.bdref_t_topologie
  ON 
     t_topologie3g.localcellid = bdref_t_topologie."LCID"
WHERE 
  dlfrequencynumber IN ('10787','10812','10836','10712')
  AND (
  (nbfreq2100orange = 4 AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR2+2%') 
  OR
  (nbfreq2100orange = 3 AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR2+1%' AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR1+2%' AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR3%' )
  OR
  (nbfreq2100orange = 2 AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR2\_%' AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR1+1%' )
  OR
  (nbfreq2100orange = 1 AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR1\_HSPA%' AND
  bdref_t_topologie."Classe" NOT LIKE 'STSR_HSPA_RS_OFR_FDD2100' )
  )

 ORDER BY
    nbfreq2100orange,
    t_topologie3g.fddcell;
