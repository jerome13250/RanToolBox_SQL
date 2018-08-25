--Mise en forme pour export format XML:

DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_creation_step1;
CREATE TABLE t_umtsfddneighbouringcell_generic_creation_step1 AS
SELECT 
  topo1.rnc, 
  topo1.provisionedsystemrelease,
  topo1.clusterid,
  topo1.nodeb, 
  topo1.fddcell,
  t_swap_l2100_10mhz_voisAlufdd7."LCIDs" AS lcid_s,
  --topo1.dlfrequencynumber AS dlfreq_s,
  topo1.locationareacode AS lac_s,
  topo1.routingareacode AS rac_s, 
  t_swap_l2100_10mhz_voisAlufdd7."NOMv" AS "umtsFddNeighbouringCell",
  t_swap_l2100_10mhz_voisAlufdd7."LCIDv" AS lcid_v, 
  --topo2.dlfrequencynumber AS dlfreq_v,
  topo2.locationareacode AS lac_v,
  topo2.routingareacode AS rac_v,
  '0.0'::text AS "mbmsNeighbouringWeight",
  '0.0'::text AS "minimumCpichEcNoValueForHoOffset",
  '0'::text AS "minimumCpichRscpValueForHoOffset",
  'sib11AndDch'::text AS "sib11OrDchUsage",
  '0707_IL_FDD7_FDD7_2sn_3dB'::text AS "umtsNeighRelationId"
  
FROM 
  public.t_swap_l2100_10mhz_voisAlufdd7, 
  public.t_topologie3g topo1, 
  public.t_topologie3g topo2
WHERE 
  t_swap_l2100_10mhz_voisAlufdd7."LCIDs" = topo1.localcellid AND
  t_swap_l2100_10mhz_voisAlufdd7."LCIDv" = topo2.localcellid AND
  topo1.rnc != 'EXTERNAL' AND
  t_swap_l2100_10mhz_voisAlufdd7."Opération" LIKE 'A%'
ORDER BY
  topo1.fddcell,
  topo2.fddcell;

--Creation de la liste de tous les neighbourcellprio possibles de 0 à 62
DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_creation_cellprio_available;
CREATE TABLE t_umtsfddneighbouringcell_generic_creation_cellprio_available AS
SELECT distinct
  t_umtsfddneighbouringcell_generic_creation_step1.fddcell, 
  t_umtsfddneighbouringcell_generic_creation_step1.lcid_s, 
  t_neighbourcellprio_list."neighbourCellPrio_list"
FROM 
  public.t_umtsfddneighbouringcell_generic_creation_step1, --pas de join car il nous faut toutes les valeurs possibles de 0 à 62
  public.t_neighbourcellprio_list
ORDER BY 
  fddcell,
  "neighbourCellPrio_list";

--Suppression des neighbourcellprio utilisés: 
DELETE FROM t_umtsfddneighbouringcell_generic_creation_cellprio_available AS ncprio_available
USING t_umtsneighbouringcell_neighbourcellprio AS ncprio_used
WHERE 
	ncprio_available.fddcell = ncprio_used.fddcell AND
	ncprio_available."neighbourCellPrio_list" = ncprio_used.neighbourcellprio;


--Ajout du ranking du ncprio:
DROP TABLE IF EXISTS t_umtsfddneighbouringcell_ncprio_available_ranked;
CREATE TABLE t_umtsfddneighbouringcell_ncprio_available_ranked AS
SELECT 
  ncprio_available.*,
  ROW_NUMBER() OVER (PARTITION BY fddcell ORDER BY "neighbourCellPrio_list"::int DESC) AS ncprio_ranking
FROM 
  public.t_umtsfddneighbouringcell_generic_creation_cellprio_available AS ncprio_available;


--Ajout du ranking du voisinage à ajouter sur la table des voisines:
DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_creation_step2_ranked;
CREATE TABLE t_umtsfddneighbouringcell_generic_creation_step2_ranked AS
SELECT 
  t_umtsfddneighbouringcell_generic_creation_step1.*,
  ROW_NUMBER() OVER (PARTITION BY fddcell ORDER BY "umtsFddNeighbouringCell" ASC) AS ncprio_ranking
FROM 
  public.t_umtsfddneighbouringcell_generic_creation_step1;

--Jointure des 2 tables ranked :
DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_creation_step3_final;
CREATE TABLE t_umtsfddneighbouringcell_generic_creation_step3_final AS
SELECT 
  t_umtsfddneighbouringcell_generic_creation_step2_ranked.*, 
  t_umtsfddneighbouringcell_ncprio_available_ranked."neighbourCellPrio_list" AS "neighbourCellPrio"
FROM 
  public.t_umtsfddneighbouringcell_generic_creation_step2_ranked INNER JOIN 
  public.t_umtsfddneighbouringcell_ncprio_available_ranked
  ON 
	t_umtsfddneighbouringcell_generic_creation_step2_ranked.fddcell = t_umtsfddneighbouringcell_ncprio_available_ranked.fddcell AND
	t_umtsfddneighbouringcell_generic_creation_step2_ranked.ncprio_ranking = t_umtsfddneighbouringcell_ncprio_available_ranked.ncprio_ranking;














