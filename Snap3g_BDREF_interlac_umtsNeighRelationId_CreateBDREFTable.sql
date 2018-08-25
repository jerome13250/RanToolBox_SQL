DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_corrections;
CREATE TABLE t_umtsfddneighbouringcell_generic_corrections AS


SELECT 
  t_voisines3g3g.rnc,
  replace(clusterid,'Cluster/','') as clusterid,
  snap3g_rnc.provisionedsystemrelease,
  t_voisines3g3g.nodeb_s as nodeb,
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
  'umtsNeighRelationId'::text AS parametre,
  'UmtsNeighbouring/0 UmtsNeighbouringRelation/' || bdref_mapping_neighbrel_interlac.neighbrel_interlac AS valeur,
  'Reselection interLAC'::text AS commentaire

  
FROM 
  public.t_voisines3g3g INNER JOIN public.bdref_mapping_neighbrel_interlac
  ON 
     t_voisines3g3g.umtsneighrelationid = bdref_mapping_neighbrel_interlac.neighbrel_intralac
  INNER JOIN
  public.snap3g_rnc
  ON
     t_voisines3g3g.rnc = snap3g_rnc.rnc
WHERE 
  t_voisines3g3g.locationareacode_s != t_voisines3g3g.locationareacode_v OR
  t_voisines3g3g.routingareacode_s != t_voisines3g3g.routingareacode_v
ORDER BY
  t_voisines3g3g.fddcell,
  t_voisines3g3g.umtsfddneighbouringcell;
