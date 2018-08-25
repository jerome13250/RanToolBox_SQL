SELECT DISTINCT
  topo1.rnc AS "RNC", 
  topo1.nodeb AS "NodeB", 
  topo1.fddcell AS "FDDCell", 
  topo2.fddcell AS "UMTSFddNeighbouringCell", 
  bdref_export_inco_neighrelid.str_valeur AS "umtsNeighRelationId"
FROM 
  public.bdref_export_inco_neighrelid INNER JOIN public.t_topologie3g topo1
  ON 
     bdref_export_inco_neighrelid.lcid = topo1.localcellid  
  INNER JOIN public.t_topologie3g topo2
  ON
     bdref_export_inco_neighrelid.lcidv = topo2.localcellid
WHERE 
  topo1.rnc IN ('ANNECYI1','ANNECYI3','LYONLACA2','LYONLACA3','LYONLACA4','LYONLACA5','LYONLACA6','LYONLACA7','LYONLACA8','LYONMONC1','LYONTRIO1','LYONTRIO2')
  
ORDER BY
  topo1.fddcell, 
  topo2.fddcell;
