--Vu l'existence des LCID à 100 millions utilisés par bdref pour identifier les voisines inconnues, on est obligé de les rechercher pour les détruire:
--lcid = mnc * 100 000 000 + rncid * 65536 + cid
--On modifie la table d'incohs :

ALTER TABLE bdref_visuincohtopo_vois_nokia
ADD COLUMN mnc TEXT,
ADD COLUMN rncid TEXT,
ADD COLUMN cellid TEXT;

--On ajoute les informations de rncid / cellid / mnc sur les LCID > 100 millions
UPDATE bdref_visuincohtopo_vois_nokia
SET 
	mnc = '0'::text || left("LCIDv",1),
	rncid = (right("LCIDv",8)::int/65536)::int::text,
	cellid = mod(right("LCIDv",8)::int,65536)::text 
WHERE 
  length(bdref_visuincohtopo_vois_nokia."LCIDv") > 8;

--Creation de la table des ADJS et ADJI a supprimer avec les données LCIDs-LCIDv
--A NOTER que cette table sera utilisée lors de la création des ADJI et ADJS pour libérer des ADJid
DROP TABLE IF EXISTS t_adjs_adji_generic_delete;
CREATE TABLE t_adjs_adji_generic_delete AS
--ADJS:
SELECT 
  t_voisines3g3g_nokia_intra."managedObject_version", 
  t_voisines3g3g_nokia_intra."WCEL_managedObject_distName", 
  t_voisines3g3g_nokia_intra."ADJS_managedObject_distName" AS "managedObject_distName",
  t_voisines3g3g_nokia_intra."managedObject_ADJS",
  bdref_visuincohtopo_vois_nokia.*,
  'ADJS'::text AS object_type
FROM 
  public.t_voisines3g3g_nokia_intra INNER JOIN public.bdref_visuincohtopo_vois_nokia
  ON
  t_voisines3g3g_nokia_intra."LCIDS" = bdref_visuincohtopo_vois_nokia."LCIDs" AND
  t_voisines3g3g_nokia_intra."LCIDV" = bdref_visuincohtopo_vois_nokia."LCIDv"
WHERE
  bdref_visuincohtopo_vois_nokia."Opération" ILIKE 'S%' AND 
  "Etats" IN ('OK','enintégration')

UNION

--ADJI :
SELECT 
  t_voisines3g3g_nokia_inter."managedObject_version", 
  t_voisines3g3g_nokia_inter."WCEL_managedObject_distName", 
  t_voisines3g3g_nokia_inter."ADJI_managedObject_distName",
  t_voisines3g3g_nokia_inter."managedObject_ADJI",
  bdref_visuincohtopo_vois_nokia.*,
  'ADJI'::text AS object_type
FROM 
  public.t_voisines3g3g_nokia_inter INNER JOIN public.bdref_visuincohtopo_vois_nokia
  ON
  t_voisines3g3g_nokia_inter."managedObject_WCEL" = bdref_visuincohtopo_vois_nokia."LCIDs" AND
  t_voisines3g3g_nokia_inter."LCIDV" = bdref_visuincohtopo_vois_nokia."LCIDv"
WHERE
  bdref_visuincohtopo_vois_nokia."Opération" ILIKE 'S%' AND 
  "Etats" IN ('OK','enintégration')

UNION

--ADJS LCID 100 Millions:
SELECT 
  t_voisines3g3g_nokia_intra."managedObject_version", 
  t_voisines3g3g_nokia_intra."WCEL_managedObject_distName", 
  t_voisines3g3g_nokia_intra."ADJS_managedObject_distName" AS "managedObject_distName",
  t_voisines3g3g_nokia_intra."managedObject_ADJS",
  bdref_visuincohtopo_vois_nokia.*,
  'ADJS'::text AS object_type
FROM 
  public.t_voisines3g3g_nokia_intra INNER JOIN public.bdref_visuincohtopo_vois_nokia
  ON
  t_voisines3g3g_nokia_intra."LCIDS" = bdref_visuincohtopo_vois_nokia."LCIDs" AND
  t_voisines3g3g_nokia_intra."AdjsCI" = bdref_visuincohtopo_vois_nokia.cellid AND
  t_voisines3g3g_nokia_intra."AdjsMNC" = bdref_visuincohtopo_vois_nokia.mnc AND
  t_voisines3g3g_nokia_intra."AdjsRNCid" = bdref_visuincohtopo_vois_nokia.rncid
WHERE
  bdref_visuincohtopo_vois_nokia."Opération" ILIKE 'S%' AND 
  "Etats" IN ('OK','enintégration')

UNION

--ADJI LCID 100 Millions:
SELECT 
  t_voisines3g3g_nokia_inter."managedObject_version", 
  t_voisines3g3g_nokia_inter."WCEL_managedObject_distName", 
  t_voisines3g3g_nokia_inter."ADJI_managedObject_distName",
  t_voisines3g3g_nokia_inter."managedObject_ADJI",
  bdref_visuincohtopo_vois_nokia.*,
  'ADJI'::text AS object_type
FROM 
  public.t_voisines3g3g_nokia_inter INNER JOIN public.bdref_visuincohtopo_vois_nokia
  ON
  t_voisines3g3g_nokia_inter."managedObject_WCEL" = bdref_visuincohtopo_vois_nokia."LCIDs" AND
  t_voisines3g3g_nokia_inter."AdjiCI" = bdref_visuincohtopo_vois_nokia.cellid AND
  t_voisines3g3g_nokia_inter."AdjiMNC" = bdref_visuincohtopo_vois_nokia.mnc AND
  t_voisines3g3g_nokia_inter."AdjiRNCid" = bdref_visuincohtopo_vois_nokia.rncid
WHERE
  bdref_visuincohtopo_vois_nokia."Opération" ILIKE 'S%' AND 
  "Etats" IN ('OK','enintégration');


--Nettoyage de la table initiale:
ALTER TABLE bdref_visuincohtopo_vois_nokia
DROP COLUMN IF EXISTS mnc,
DROP COLUMN IF EXISTS rncid,
DROP COLUMN IF EXISTS cellid;








