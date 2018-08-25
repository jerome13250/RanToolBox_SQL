--Crée la table des freq_configs, utiles dans de nombreuses requêtes
--Donne les freq_config u2100 sur le terrain:
DROP TABLE IF EXISTS t_nokiapower_freqconfig;
CREATE TABLE t_nokiapower_freqconfig AS
SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL"."SectorID",
  'U2100'::text AS bande, 
  string_agg("nokia_WCEL"."UARFCN", '-' ORDER BY "nokia_WCEL"."UARFCN") AS freq_config
FROM 
  public."nokia_WCEL" LEFT JOIN public."nokia_LCELW"
  ON
	"nokia_WCEL"."managedObject_WCEL" = "nokia_LCELW"."managedObject_LCELW"
WHERE
  "UARFCN"::int > 10000  --frequences U2100
  AND NOT ("nokia_WCEL"."UARFCN" = '10712' AND "nokia_LCELW"."maxCarrierPower"='0') --On exclue les FDD7 en cours de création avec puissance=0
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent", 
  "nokia_WCEL"."SectorID"

  
UNION --Liste les freq_config U900:

SELECT 
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID",
  'U900'::text AS bande, 
  string_agg("nokia_WCEL"."UARFCN", '-' ORDER BY "nokia_WCEL"."UARFCN") AS freq_config
  --COUNT("nokia_WCEL"."UARFCN")
FROM 
  public."nokia_WCEL"
WHERE
  "UARFCN"::int < 10000
GROUP BY
  "nokia_WCEL"."managedObject_distName_parent", 
  --"nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."SectorID";
 