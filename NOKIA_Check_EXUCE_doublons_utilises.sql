--Cette requete permet de voir quelles sont les doublons d'EXUCE et leurs nombres de voisines

--Cree le rapport du nombre+type de voisines pour chaque targetcellDN
DROP TABLE IF EXISTS tmp_exuce_count_neighbours;
CREATE TABLE tmp_exuce_count_neighbours AS

    SELECT * FROM crosstab(
        $$
	SELECT
	  "TargetCellDN",
	  'ADJS'::text AS neigh_type,
	  COUNT("TargetCellDN") AS neigh_count
	FROM public."nokia_ADJS"
	GROUP BY 
	  "TargetCellDN"

	UNION

	SELECT
	  "TargetCellDN",
	  'ADJI'::text AS neigh_type,
	  COUNT("TargetCellDN")
	FROM public."nokia_ADJI"
	GROUP BY 
	  "TargetCellDN"

	UNION

	SELECT
	  "targetCellDN",
	  'ADJW'::text AS neighbour_type,
	  COUNT("targetCellDN") 
	FROM public."nokia_ADJW"
	GROUP BY 
	  "targetCellDN"

	UNION

	SELECT
	  "targetCellDn",
	  'LNRELW'::text AS neighbour_type,
	  COUNT("targetCellDn")
	FROM public."nokia_LNRELW"
	GROUP BY 
	  "targetCellDn"

	UNION

	SELECT
	  "targetCellDn",
	  'LNADJW'::text AS neighbour_type,
	  COUNT("targetCellDn")
	FROM public."nokia_LNADJW"
	GROUP BY 
	  "targetCellDn"

	ORDER BY "TargetCellDN" --Attention: Obligatoire de mettre dans l'ordre pour la fonction crosstab
	
	$$,
        -- select sous forme Clef, Future colonne, valeur

        $$VALUES ('ADJS'::text),('ADJI'::text), ('ADJW'::text), ('LNRELW'::text), ('LNADJW'::text)$$)

    AS ct (  "TargetCellDN" text, "ADJS" int , "ADJI" int,"ADJW" int,"LNRELW" int, "LNADJW" int);


--Vérification des exuce en doublons avec nombre de vois de chaque type:
DROP TABLE IF EXISTS t_exuce_doubles_neighbours;
CREATE TABLE t_exuce_doubles_neighbours AS
SELECT DISTINCT
  exuce1."managedObject_EXUCE" AS "managedObject_EXUCE1", 
  exuce1."name",
  exuce1.mcc, 
  exuce1.mnc, 
  exuce1."rncId",
  exuce1."cId",
  count1.*,
  exuce2."managedObject_EXUCE" AS "managedObject_EXUCE2",
  exuce2."name" AS name2
FROM 
  public."nokia_EXUCE" exuce1
  
  INNER JOIN public."nokia_EXUCE" exuce2
  ON --Les EXUCE ont les mêmes cId, rncId, mcc, mnc
	exuce1."cId" = exuce2."cId" AND
	exuce1.mcc = exuce2.mcc AND
	exuce1.mnc = exuce2.mnc AND
	exuce1."rncId" = exuce2."rncId"
  LEFT JOIN tmp_exuce_count_neighbours AS count1
  ON
	exuce1."managedObject_distName" = count1."TargetCellDN"
WHERE
  exuce1."managedObject_distName" != exuce2."managedObject_distName" --les EXUCE sont différents
ORDER BY
  exuce1.mcc, 
  exuce1.mnc,
  exuce1."rncId",
  exuce1."cId";



