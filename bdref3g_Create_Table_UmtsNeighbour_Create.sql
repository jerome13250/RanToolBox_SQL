--Comme on n'a pas les infos BDREF, on besoin d'un mapping par défaut entre frequence_s , frequence_v et umtsNeighRelationId
--ça va servir de valeur approximative pour allouer la valeur, on laisse BDREF corriger les params croisés le jour suivant
DROP TABLE IF EXISTS t_umtsneighbouringcell_mapping_freq_umtsneighrelationid;
CREATE TABLE t_umtsneighbouringcell_mapping_freq_umtsneighrelationid AS
SELECT 
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.dlfrequencynumber_v,
  COUNT(t_voisines3g3g.umtsneighrelationid) AS NB
FROM 
  public.t_voisines3g3g
WHERE
  t_voisines3g3g.umtsneighrelationid NOT LIKE '%Femto%'  --On exclue les FEMTO car cas particulier
GROUP BY
  t_voisines3g3g.umtsneighrelationid, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.dlfrequencynumber_v
ORDER BY
  t_voisines3g3g.umtsneighrelationid ASC,
  NB DESC;

--ON calcule la valeur max:
DROP TABLE IF EXISTS t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_max;
CREATE TABLE t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_max AS

SELECT 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_s, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_v, 
  --t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.umtsneighrelationid, 
  MAX(t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.nb) AS max_nb
FROM 
  public.t_umtsneighbouringcell_mapping_freq_umtsneighrelationid
GROUP BY
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_s, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_v;

--On retrouve l'umtsneighrelationid la plus probable:
DROP TABLE IF EXISTS t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3;
CREATE TABLE t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3 AS

SELECT 
  min(t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.umtsneighrelationid) AS umtsneighrelationid, --En cas de doublon avec valeur max identique choisis une seule valeur
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_s, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_v, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.nb
FROM 
  public.t_umtsneighbouringcell_mapping_freq_umtsneighrelationid, 
  public.t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_max
WHERE 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_s = t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_max.dlfrequencynumber_s AND
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_v = t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_max.dlfrequencynumber_v AND
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.nb = t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_max.max_nb
GROUP BY
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_s, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_v, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.nb
ORDER BY
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_s, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid.dlfrequencynumber_v;

--Table finale mapping: on rajoute les interlac
DROP TABLE IF EXISTS t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_final;
CREATE TABLE t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_final AS

SELECT 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3.dlfrequencynumber_s, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3.dlfrequencynumber_v, 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3.umtsneighrelationid, 
  bdref_mapping_neighbrel_interlac.neighbrel_interlac AS umtsneighrelationid_interlac
FROM 
  public.t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3 LEFT JOIN public.bdref_mapping_neighbrel_interlac
ON 
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3.umtsneighrelationid = bdref_mapping_neighbrel_interlac.neighbrel_intralac
ORDER BY
  t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3.umtsneighrelationid;

 --nettoyage :
 DROP TABLE IF EXISTS t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_step3;
DROP TABLE IF EXISTS t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_max;
DROP TABLE IF EXISTS t_umtsneighbouringcell_mapping_freq_umtsneighrelationid;

--On cree la table avec les infos nécessaires pour créer des voisines
--Attention : rajouter le cas Supercell
DROP TABLE IF EXISTS t_umtsfddneighbouringcell_generic_creation_step1;
CREATE TABLE t_umtsfddneighbouringcell_generic_creation_step1 AS
SELECT 
  topo1.rnc, 
  topo1.provisionedsystemrelease,
  topo1.clusterid,
  topo1.nodeb, 
  topo1.fddcell,
  bdref_visuincohtopo_vois."LCIDs" AS lcid_s,
  topo1.dlfrequencynumber AS dlfreq_s,
  topo1.locationareacode AS lac_s,
  topo1.routingareacode AS rac_s, 
  topo2.fddcell AS "umtsFddNeighbouringCell",
  bdref_visuincohtopo_vois."LCIDv" AS lcid_v, 
  topo2.dlfrequencynumber AS dlfreq_v,
  topo2.locationareacode AS lac_v,
  topo2.routingareacode AS rac_v,
  '0.0'::text AS "mbmsNeighbouringWeight",
  '0.0'::text AS "minimumCpichEcNoValueForHoOffset",
  '0'::text AS "minimumCpichRscpValueForHoOffset",
  CASE  WHEN (topo2.fddcell LIKE 'SuperCell%') --vers supercell
		THEN 'sib11Usage'
	ELSE 'dchUsage'::text
  END AS "sib11OrDchUsage",
   
  CASE  WHEN (topo1.dlfrequencynumber = '10787' AND topo2.fddcell LIKE 'SuperCell%') --fdd10 vers supercell
		THEN '1077_ST_FDD10_FemtoFDD7_STANDARD'
	WHEN (topo1.dlfrequencynumber = '10812' AND topo2.fddcell LIKE 'SuperCell%') --fdd11 vers supercell
		THEN '1177_ST_FDD11_FemtoFDD7_STANDARD'
	WHEN (topo1.dlfrequencynumber = '10836' AND topo2.fddcell LIKE 'SuperCell%') --fdd12 vers supercell
		THEN '1277_ST_FDD12_FemtoFDD7_STANDARD'
	WHEN (topo1.dlfrequencynumber = '10712' AND topo2.fddcell LIKE 'SuperCell%') --fdd7 vers supercell
		THEN '0777_ST_FDD7_FemtoFDD7_STANDARD'
	WHEN (topo1.dlfrequencynumber = '3011' AND topo2.fddcell LIKE 'SuperCell%') --fdd7 vers supercell
		THEN '9077_ST_FDD900_FemtoFDD7_STANDARD'
	WHEN (topo1.locationareacode != topo2.locationareacode OR topo1.routingareacode != topo2.routingareacode) --Lac ou rac différentes
		THEN COALESCE(t_mapping.umtsneighrelationid_interlac,t_mapping.umtsneighrelationid)--si une version interlac existe on la prend, sinon version normale
	ELSE t_mapping.umtsneighrelationid
  END AS "umtsNeighRelationId"
  
FROM 
  public.bdref_visuincohtopo_vois, 
  public.t_topologie3g topo1, 
  public.t_topologie3g topo2, 
  public.t_umtsneighbouringcell_mapping_freq_umtsneighrelationid_final AS t_mapping
WHERE 
  bdref_visuincohtopo_vois."LCIDs" = topo1.localcellid AND
  bdref_visuincohtopo_vois."LCIDv" = topo2.localcellid AND
  topo1.dlfrequencynumber = t_mapping.dlfrequencynumber_s AND
  topo2.dlfrequencynumber = t_mapping.dlfrequencynumber_v AND
  topo1.rnc != 'EXTERNAL' AND
  bdref_visuincohtopo_vois."Opération" LIKE 'A%'
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
  ROW_NUMBER() OVER (PARTITION BY fddcell ORDER BY "neighbourCellPrio_list"::int ASC) AS ncprio_ranking
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














