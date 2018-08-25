--Crée la table des freq_configs, utiles dans de nombreuses requêtes
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
  "nokia_WCEL"."SectorID"
;
 