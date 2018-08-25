SELECT 
  bdref_t_topologie.bdref_idcell, 
  bdref_t_topologie."LCID", 
  bdref_t_topologie."NIDT", 
  bdref_t_topologie."NOEUD", 
  bdref_t_topologie."Classe", 
  t_topologie3g.fddcell,
  t_topologie3g.nodeb, 
  snap3g_vamparameters.vamparameters, 
  snap3g_vamparameters.vamamplitudecoeff, 
  snap3g_vamparameters.vamphasecoeff
FROM 
  public.bdref_t_topologie INNER JOIN public.t_topologie3g
  ON
     bdref_t_topologie."LCID" = t_topologie3g.localcellid
  
  LEFT JOIN public.snap3g_vamparameters
  ON 
     t_topologie3g.btsequipment = snap3g_vamparameters.btsequipment AND
     t_topologie3g.btscell = snap3g_vamparameters.btscell
WHERE 
   bdref_t_topologie."Classe" LIKE 'STSR3%' AND
   snap3g_vamparameters.vamparameters IS NULL AND
   t_topologie3g.nodeb IS NOT NULL
ORDER BY
   t_topologie3g.fddcell
   ;
   
  
