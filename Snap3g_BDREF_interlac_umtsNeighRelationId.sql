SELECT 
  t_voisines3g3g.rnc, 
  t_voisines3g3g.fddcell,
  t_voisines3g3g.localcellid_s AS LCIDS, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.locationareacode_s,
  t_voisines3g3g.routingareacode_s, 
  t_voisines3g3g.umtsfddneighbouringcell,
  t_voisines3g3g.localcellid_v AS LCIDV, 
  t_voisines3g3g.dlfrequencynumber_v, 
  t_voisines3g3g.locationareacode_v, 
  t_voisines3g3g.routingareacode_v,
  t_voisines3g3g.umtsneighrelationid AS omc_umtsneighrelationid, 
  'umtsNeighRelationId' AS parametre,
  'UmtsNeighbouring/0 UmtsNeighbouringRelation/' || bdref_mapping_neighbrel_interlac.neighbrel_interlac AS valeur,
  'Reselection interLAC' AS commentaire

  
FROM 
  public.t_voisines3g3g INNER JOIN public.bdref_mapping_neighbrel_interlac
  ON 
     t_voisines3g3g.umtsneighrelationid = bdref_mapping_neighbrel_interlac.neighbrel_intralac
WHERE 
  t_voisines3g3g.locationareacode_s != t_voisines3g3g.locationareacode_v OR
  t_voisines3g3g.routingareacode_s != t_voisines3g3g.routingareacode_v
ORDER BY
  t_voisines3g3g.fddcell,
  t_voisines3g3g.umtsfddneighbouringcell;
