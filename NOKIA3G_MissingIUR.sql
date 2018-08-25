--Creation de la table des voisines inter RNC NOKIA
DROP TABLE IF EXISTS t_voisines_interrnc_nokia;
CREATE TABLE t_voisines_interrnc_nokia AS

SELECT 
rnc_id_s,
rnc_id_v,
COUNT(rnc_id_s) AS vois_count
FROM (

	SELECT 
	  rnc_id_s, 
	  "AdjsRNCid" AS rnc_id_v
	FROM 
	  public.t_voisines3g3g_nokia_intra
	WHERE 
	  rnc_id_s != "AdjsRNCid"

	UNION ALL

	SELECT 
	  rnc_id_s, 
	  "AdjiRNCid" AS rnc_id_v
	FROM 
	  public.t_voisines3g3g_nokia_inter
	WHERE 
	  rnc_id_s != "AdjiRNCid"

) AS t

GROUP BY 
  rnc_id_s, 
  rnc_id_v
  
ORDER BY
  vois_count DESC;

--Creation de la table des missing iur nokia
DROP TABLE IF EXISTS t_voisines_interrnc_nokia_missing;
CREATE TABLE t_voisines_interrnc_nokia_missing AS
SELECT 
  t_rncServing.name,
  t_voisines_interrnc_nokia.rnc_id_s,
  COALESCE(t_rncNeighbourNokia.name,snap3g_rnc.rnc) AS neighbourRNC,
  t_voisines_interrnc_nokia.rnc_id_v, 
  t_voisines_interrnc_nokia.vois_count
FROM 
  public.t_voisines_interrnc_nokia LEFT JOIN public."nokia_IUR"
  ON
	t_voisines_interrnc_nokia.rnc_id_v = "nokia_IUR"."managedObject_IUR"
  LEFT JOIN public."nokia_RNC"
  ON 
	t_voisines_interrnc_nokia.rnc_id_s = "nokia_RNC"."managedObject_RNC" AND
	"nokia_IUR"."managedObject_distName_parent" = "nokia_RNC"."managedObject_distName"
  INNER JOIN public."nokia_RNC" AS t_rncServing ON
	t_voisines_interrnc_nokia.rnc_id_s = t_rncServing."managedObject_RNC"
  LEFT JOIN public."nokia_RNC" AS t_rncNeighbourNokia ON
	t_voisines_interrnc_nokia.rnc_id_v = t_rncNeighbourNokia."managedObject_RNC"
  LEFT JOIN public.snap3g_rnc ON
	t_voisines_interrnc_nokia.rnc_id_v = snap3g_rnc.rncid
WHERE
  "nokia_IUR"."managedObject_IUR" IS NULL AND
  rnc_id_v != '159' --Exclusion des FemtoCells
ORDER BY
  vois_count DESC;
;
