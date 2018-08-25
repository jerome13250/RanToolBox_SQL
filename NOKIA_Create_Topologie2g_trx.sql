-- Creation de la table topologie trx nokia:
DROP TABLE IF EXISTS t_topologie2g_trx_nokia;
CREATE TABLE t_topologie2g_trx_nokia AS

SELECT
  "nokia_BCF"."managedObject_distName" AS "BCF_managedObject_distName",
  "nokia_BCF".name AS "BCF_name",
  "nokia_BCF"."siteTemplateDescription" AS "BCF_siteTemplateDescription",
  "nokia_BCF"."SBTSId",
  "nokia_BTS"."managedObject_distName" AS "BTS_managedObject_distName", 
  "nokia_BTS"."managedObject_BTS", 
  "nokia_BTS".name AS "BTS_name",
  right("nokia_BTS".name, 1) AS sectorid,
  "nokia_BTS"."adminState" AS "BTS_adminState", --1:ONLINE / 3:OFFLINE
  "nokia_BTS"."frequencyBandInUse", --0:GSM / 1:DCS  
  "nokia_TRX"."managedObject_TRX", 
  "nokia_TRX"."adminState" AS "TRX_adminState",
  "nokia_TRX"."trxRfPower"
FROM 
  public."nokia_TRX" INNER JOIN public."nokia_BTS"
  ON
	"nokia_TRX"."managedObject_distName_parent" = "nokia_BTS"."managedObject_distName"
  INNER JOIN "nokia_BCF"
  ON
	"nokia_BTS"."managedObject_distName_parent" = "nokia_BCF"."managedObject_distName"
ORDER BY
  "nokia_BTS".name,
  "nokia_TRX"."managedObject_TRX"
  ;
