SELECT 
  topo1.rnc, 
  topo1.rncid, 
  topo1.nodeb, 
  topo1.fddcell AS fddcell1, 
  bdref1."Classe" AS classe1, 
  topo2.fddcell AS fddcell2, 
  bdref2."Classe" AS classe2
FROM 
  public.t_topologie3g topo1 INNER JOIN public.t_topologie3g topo2
  ON 
    topo1.nodeb = topo2.nodeb
  INNER JOIN public.bdref_t_topologie bdref1
  ON
     topo1.localcellid = bdref1."LCID"
  INNER JOIN public.bdref_t_topologie bdref2
  ON
     topo2.localcellid = bdref2."LCID"
WHERE 
  bdref1."Classe" LIKE '%HotSpot'
  AND bdref2."Classe" NOT LIKE '%HotSpot'
  AND bdref2."Classe" != ''
  AND topo2.dlfrequencynumber != '3011'
ORDER BY
  topo1.fddcell;
