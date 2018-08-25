SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.rncid_s, 
  t_voisines3g3g.nodeb_s, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.locationareacode_s, 
  t_voisines3g3g.routingareacode_s, 
  t_voisines3g3g.rnc_v, 
  t_voisines3g3g.rncid_v, 
  t_voisines3g3g.nodeb_v, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.localcellid_v, 
  t_voisines3g3g.locationareacode_v, 
  t_voisines3g3g.routingareacode_v, 
  t_voisines3g3g.sib11ordchusage, 
  t_voisines3g3g.umtsneighrelationid
FROM 
  public.t_voisines3g3g
WHERE 
  localcellid_s IN ('180161','180164','180162','180165','180163','180166','221441','221444','221442','221445','221443','221446','212701','212704',
  '212702','212705','212703','212706','228661','228664','228662','228665','228663','228666','230481','230484','230482','230485','230483',
  '230486','201381','201384','201382','201385','201383','201386','189671','189674','189672','189675','189673','189676','228671','228674',
  '228672','228675','228673','228676','209811','209814','209812','209815','209813','209816','282451','282452','234401','234404','234403',
  '234406','189821','189824','189822','189825','189823','189826','227881','227884','227882','227885','227883','227886','227911','227914',
  '227912','227915','227913','227916','230431','230434','230432','230435','230433','230436','204571','204574','204572','204575','204573',
  '204576','211871','211874','211872','211875','211873','211876','212731','212734','212732','212735','212733','212736','204261','204264',
  '204262','204265','204263','204266')
  AND
   ( ( dlfrequencynumber_s = '10787' AND dlfrequencynumber_v='10812') OR
     ( dlfrequencynumber_s = '10812' AND dlfrequencynumber_v='10787') )
ORDER BY
  fddcell,
  umtsfddneighbouringcell;
