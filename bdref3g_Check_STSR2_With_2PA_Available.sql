--Requete permettant de trouver les STSR2 alors que 2 PA sont dispos par secteur

SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.dlfrequencynumber, 
  MAX(t_topologie3g.sector_number) AS sectors
FROM 
  public.t_topologie3g INNER JOIN public.bdref_t_topologie
    ON
      t_topologie3g.localcellid = bdref_t_topologie."LCID"
WHERE 
  t_topologie3g.dlfrequencynumber = '10787' AND 
  t_topologie3g.nodeb IS NOT NULL AND
  bdref_t_topologie."Classe" LIKE 'STSR2\_%' -- "\" caractere d'echappement
GROUP BY
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.runningsoftwareversion, 
  t_topologie3g.dlfrequencynumber
ORDER BY
  t_topologie3g.nodeb
;
