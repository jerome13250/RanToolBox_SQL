DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_corrections;
CREATE TABLE t_umtsfddneighbouringcell_generic_corrections AS

SELECT 
  t_voisines3g3g.rnc, 
  snap3g_rnc.clusterid, 
  snap3g_rnc.provisionedsystemrelease, 
  t_voisines3g3g.nodeb_s AS nodeb, 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  'umtsNeighRelationId'::text AS parametre, 
  'UmtsNeighbouring/0 UmtsNeighbouringRelation/' || bdref_mapping_neighbrel_interlac.neighbrel_interlac AS valeur
FROM 
  public.t_voisines3g3g INNER JOIN public.snap3g_rnc
  ON
	t_voisines3g3g.rnc = snap3g_rnc.rnc 
  INNER JOIN public.t_swap_l2100_10mhz_action tswap1
  ON
	t_voisines3g3g.umtsfddneighbouringcell = tswap1.fddcell
  INNER JOIN public.bdref_mapping_neighbrel_interlac
  ON
	t_voisines3g3g.umtsneighrelationid = bdref_mapping_neighbrel_interlac.neighbrel_intralac
  LEFT JOIN public.t_swap_l2100_10mhz_action tswap2
  ON
	t_voisines3g3g.fddcell = tswap2.fddcell
WHERE 
	tswap2.fddcell IS NULL AND --on exclue les voisines du site swappé car elles n'ont plus de raison d'exister
	tswap1.dlfrequencynumber NOT IN ('10812','10836') --les voisines vers fdd11 et fdd12 ont été détruites
ORDER BY 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.umtsfddneighbouringcell
  ;
