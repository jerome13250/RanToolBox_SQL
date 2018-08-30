--Fusion de la table MRBTS dans la table SBTS, cela a pour but d'éviter de réécrire et complexifier toutes les autres requêtes qui utilisaient
--l'objet MRBTS. A terme lors de la disparition du SBTS, il faudra supprimer cette fusion et modifier les autres requêtes.

INSERT INTO "nokia_SBTS" (
  "managedObject_version",
  "managedObject_id",
  "managedObject_distName",
  "managedObject_distName_parent",
  "managedObject_SBTS",
  "btsProfile",
  "activeSWReleaseVersion",
  "defaults_name",
  "name",
  "operationalState",
  "sbtsDescription",
  "sbtsName",
  "siteTemplateName"

  )
 SELECT
 
  "nokia_MRBTS"."managedObject_version",
  "nokia_MRBTS"."managedObject_id",
  "nokia_MRBTS"."managedObject_distName",
  "nokia_MRBTS"."managedObject_distName_parent",
  "nokia_MRBTS"."managedObject_MRBTS" AS "managedObject_SBTS",
  'MRBTS_noProfile'::text AS "btsProfile",
  "nokia_MNL_R"."activeSWReleaseVersion" AS "activeSWReleaseVersion",
  "nokia_MRBTS".defaults_name,
  "nokia_MRBTS".name,
  'MRBTS_noInfo'::text AS "operationalState",
  "descriptiveName" AS "sbtsDescription",
  "nokia_MRBTS"."btsName" AS "sbtsName",
  "nokia_MRBTS"."siteTemplateName"

FROM public."nokia_MNL_R"

LEFT JOIN "nokia_MNL"
    ON
    "nokia_MNL"."managedObject_distName" = "nokia_MNL_R"."managedObject_distName_parent"

LEFT JOIN "nokia_MRBTS"
    ON
    "nokia_MRBTS"."managedObject_distName" = "nokia_MNL"."managedObject_distName_parent"

LEFT JOIN public."nokia_SBTS"
    ON
	--On utilise les id simples car il y a des doublons temporaires entre SBTSid et MRBTSid lors du passage en SRAN17 :
	"nokia_MRBTS"."managedObject_MRBTS"="nokia_SBTS"."managedObject_SBTS"  

LEFT JOIN "nokia_MRBTSDESC"
	ON
	"nokia_MRBTS"."managedObject_distName" = "nokia_MRBTSDESC"."managedObject_distName_parent"

WHERE
  "nokia_SBTS"."managedObject_distName" IS NULL --on rajoute cette jointure pour éviter en cas de reproceesing de rerajouter les MRBTS
;

