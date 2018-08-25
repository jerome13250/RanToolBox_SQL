DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_corrections;
CREATE TABLE t_umtsfddneighbouringcell_generic_corrections AS

SELECT 
  t_voisines3g3g.rnc, 
  snap3g_rnc.provisionedsystemrelease, 
  snap3g_rnc.clusterid,
  t_voisines3g3g.nodeb_s AS nodeb,  
  t_voisines3g3g.fddcell,
  t_voisines3g3g.localcellid_s AS "LCIDs",
  t_voisines3g3g.umtsfddneighbouringcell,
  t_voisines3g3g.localcellid_v AS "LCIDv", 
  'umtsNeighRelationId'::text AS parametre, 
  bdref_mapping_neighbrel_interlac.neighbrel_interlac AS valeur
FROM 
  public.t_voisines3g3g INNER JOIN public.swap_list_lcid
  ON
     t_voisines3g3g.localcellid_v = swap_list_lcid."LCID"
  INNER JOIN public.snap3g_rnc
  ON 
    snap3g_rnc.rnc = t_voisines3g3g.rnc
  INNER JOIN public.bdref_mapping_neighbrel_interlac
  ON 
    bdref_mapping_neighbrel_interlac.neighbrel_intralac = t_voisines3g3g.umtsneighrelationid

  LEFT JOIN public.swap_list_lcid AS swaplist2 --permet d'exclure les vois intra site avec la condition NULL
  ON
     t_voisines3g3g.localcellid_s = swaplist2."LCID"
WHERE
  swaplist2."LCID" IS NULL; --permet d'exclure les vois intra site
