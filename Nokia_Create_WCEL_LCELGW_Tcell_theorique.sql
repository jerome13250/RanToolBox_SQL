--Permet de retrouver les freq_config toutes fréquences de tous les secteurs:
DROP TABLE IF EXISTS t_nokia_freqconfig_all;
CREATE TABLE t_nokia_freqconfig_all AS
SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL"."SectorID", 
  string_agg("nokia_WCEL"."UARFCN", '-' ORDER BY "nokia_WCEL"."UARFCN") AS freq_config_all
FROM 
  public."nokia_WCEL" LEFT JOIN public."nokia_LCELW"
  ON
	"nokia_WCEL"."managedObject_WCEL" = "nokia_LCELW"."managedObject_LCELW"
WHERE
  NOT ("nokia_WCEL"."UARFCN" = '10712' AND "nokia_LCELW"."maxCarrierPower"='0') --On exclue les FDD7 en cours de création avec puissance=0
  
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL"."SectorID";

--Permet de trouver le nombre de secteurs par sites :
--Permet de retrouver les freq_config toutes fréquences de tous les secteurs:
DROP TABLE IF EXISTS t_nokia_site_sector_nb;
CREATE TABLE t_nokia_site_sector_nb AS
SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  MAX("nokia_WCEL"."SectorID") AS "site_sector_nb"
FROM 
  public."nokia_WCEL"  
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent";

--Table theorique de parametrages TCELL et LCELGWid: ATTENTION TROUVER LES NOUVEAUX OBJETS LCELGW SOUS MRBTS !!!
SELECT 
  "nokia_WCEL".name,
  "nokia_WCEL"."managedObject_version",
  "nokia_WCEL"."managedObject_distName",
  "nokia_WCEL"."managedObject_distName_parent",
  "nokia_WCEL"."managedObject_WCEL",
  "nokia_WCEL"."UARFCN",
  t_nokia_site_sector_nb.site_sector_nb,
  t_nokia_freqconfig_all.freq_config_all
FROM 
  public."nokia_WCEL" LEFT JOIN public.t_nokia_freqconfig_all
  ON
	"nokia_WCEL"."managedObject_distName_parent" = t_nokia_freqconfig_all."managedObject_distName_parent" AND
	"nokia_WCEL"."SectorID" = t_nokia_freqconfig_all."SectorID"
  LEFT JOIN t_nokia_site_sector_nb
  ON
	"nokia_WCEL"."managedObject_distName_parent" = t_nokia_site_sector_nb."managedObject_distName_parent"
ORDER BY 
  "nokia_WCEL".name

;

