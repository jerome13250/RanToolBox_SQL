--------------------------------------------------------------------------
--				Requete config frequentielle globale					--
--------------------------------------------------------------------------


DROP TABLE IF EXISTS "t_freqconf3G";
-- creation table temporaire 3G
CREATE  TABLE "t_freqconf3G" AS 
   SELECT
      "SBTSId", 
      string_agg(freq, '-' ORDER BY freq) AS freq_config_3G
    FROM 
      ( 
      --Sous requete 3G:
      SELECT DISTINCT --cellule 3G (10712 = FDD7 / 10787 = FDD10 / 10812 = FDD11 / 10836 = FDD12 / 3011 = U900)
        "nokia_WBTS"."SBTSId", 
        (
        CASE
            WHEN "nokia_WCEL"."UARFCN" = '10712' THEN 'FDD7'
            WHEN "nokia_WCEL"."UARFCN" = '10787' THEN 'FDD10'
            WHEN "nokia_WCEL"."UARFCN" = '10812' THEN 'FDD11'
            WHEN "nokia_WCEL"."UARFCN" = '10836' THEN 'FDD12'
            WHEN "nokia_WCEL"."UARFCN" = '3011' THEN 'U900'
            WHEN "nokia_WCEL"."UARFCN" = '2950' THEN 'U900_RS_BYT'
            WHEN "nokia_WCEL"."UARFCN" = '3037' THEN 'U900_RS_FRM'
            WHEN "nokia_WCEL"."UARFCN" = '3075' THEN 'U900_RS_SFR'
            ELSE 'ERROR UMTS'
        END
        ) AS freq
        FROM "nokia_WCEL" INNER JOIN "nokia_WBTS"
           ON
            "nokia_WCEL"."managedObject_distName_parent" = "nokia_WBTS"."managedObject_distName"
        ) AS t

		GROUP BY
		t."SBTSId";
        
        
DROP TABLE IF EXISTS "t_freqconf4G";
-- creation table temporaire 4G
CREATE  TABLE "t_freqconf4G" AS      
    SELECT
          "SBTSId",
          string_agg(freq, '-' ORDER BY freq) AS freq_config_4G
        FROM 
          ( 

            SELECT DISTINCT --cellule 4G ( 1300 = L1800 / 3000 = L2600 / 6400= L800 / 547 = L2100)
                "nokia_SBTS"."managedObject_SBTS" AS "SBTSId",
                "nokia_SBTS"."name",
                (
                CASE
                    WHEN "nokia_LNCEL"."earfcnDL" = '1300' THEN 'LTE1800'
                    WHEN "nokia_LNCEL"."earfcnDL" = '3000' THEN 'LTE2600'
                    WHEN "nokia_LNCEL"."earfcnDL" = '6400' THEN 'LTE800'
                    WHEN "nokia_LNCEL"."earfcnDL" = '547' THEN 'LTE2100'
                    ELSE 'ERROR LTE'
                END
                ) AS freq
             FROM "nokia_LNCEL" INNER JOIN "nokia_LNBTS"
             ON
                "nokia_LNCEL"."managedObject_distName_parent" = "nokia_LNBTS"."managedObject_distName"
             INNER JOIN "nokia_SBTS"
             ON
                "nokia_LNBTS"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"

             WHERE "nokia_SBTS"."managedObject_version" ='SBTS16.10' -- enleve les MRBTS

            UNION

            SELECT 
                "nokia_MRBTS"."managedObject_MRBTS" AS "SBTSId",
                "nokia_MRBTS"."btsName",
                    (
                    CASE
                        WHEN "nokia_LNCEL_FDD"."earfcnDL" = '1300' THEN 'LTE1800'
                        WHEN "nokia_LNCEL_FDD"."earfcnDL" = '3000' THEN 'LTE2600'
                        WHEN "nokia_LNCEL_FDD"."earfcnDL" = '6400' THEN 'LTE800'
                        WHEN "nokia_LNCEL_FDD"."earfcnDL" = '547' THEN 'LTE2100'
                        ELSE 'ERROR LTE'
                    END
                    ) AS freq

            FROM "nokia_MRBTS" JOIN "nokia_LNBTS"
            ON 
            	"nokia_LNBTS"."managedObject_distName_parent" = "nokia_MRBTS"."managedObject_distName"
                
            LEFT JOIN "nokia_LNCEL" 
            ON
            	"nokia_LNCEL"."managedObject_distName_parent" = "nokia_LNBTS"."managedObject_distName"
            
            LEFT JOIN "nokia_LNCEL_FDD" 
            ON
            	"nokia_LNCEL_FDD"."managedObject_distName_parent" = "nokia_LNCEL"."managedObject_distName"


        ) AS t


    GROUP BY
    t."SBTSId";
    
DROP TABLE IF EXISTS "t_freqconf2G";
-- creation table temporaire 2G
CREATE  TABLE "t_freqconf2G" AS 
    SELECT
      "SBTSId", 
      string_agg(freq, '-' ORDER BY freq) AS freq_config_2G
    FROM 
      ( 
        SELECT DISTINCT --cellule 2G (0 = G900 / 1 = G1800)
            "nokia_BCF"."SBTSId" AS "SBTSId", 
            (
            CASE
                WHEN "nokia_BTS"."frequencyBandInUse" = '0' THEN 'G900'
                WHEN "nokia_BTS"."frequencyBandInUse" = '1' THEN 'G1800'
                ELSE 'ERROR GSM'
            END
            ) AS freq
            FROM "nokia_BCF" INNER JOIN "nokia_BTS"
            ON
            	"nokia_BCF"."managedObject_distName" = "nokia_BTS"."managedObject_distName_parent"
            ORDER BY freq
       ) AS t

    GROUP BY
      t."SBTSId";



DROP TABLE IF EXISTS "t_freqconfglobale";
--- creation table freqconfglobale
CREATE TABLE "t_freqconfglobale" AS 

    SELECT 

    CASE
        WHEN "t_freqconf2G"."SBTSId" = "t_freqconf2G"."SBTSId" THEN "t_freqconf2G"."SBTSId"
    ELSE (
            CASE
                WHEN "t_freqconf3G"."SBTSId" = "t_freqconf3G"."SBTSId" THEN "t_freqconf3G"."SBTSId"        

            ELSE (                
                    CASE
                        WHEN "t_freqconf4G"."SBTSId" = "t_freqconf4G"."SBTSId" THEN "t_freqconf4G"."SBTSId"
                        ELSE 'ERROR'
                    END                              
            )END
    )END AS "SBTSId",
    COALESCE("t_freqconf2G"."freq_config_2g", '-') AS "freq_config_2g",
    COALESCE("t_freqconf3G"."freq_config_3g", '-') AS "freq_config_3g",
    COALESCE("t_freqconf4G"."freq_config_4g", '-') AS "freq_config_4g",

    CONCAT(
               COALESCE("t_freqconf2G"."freq_config_2g", '-'),
                ' / ',
               COALESCE("t_freqconf3G"."freq_config_3g", '-'),
                ' / ',
               COALESCE("t_freqconf4G"."freq_config_4g", '-')
          ) AS freq_config_globale


    FROM

    "t_freqconf3G" FULL JOIN "t_freqconf4G"
    ON
    "t_freqconf3G"."SBTSId" = "t_freqconf4G"."SBTSId"

    FULL JOIN "t_freqconf2G"
    ON
    "t_freqconf3G"."SBTSId" = "t_freqconf2G"."SBTSId"


    ORDER BY "SBTSId";
   
-- supprime les tables temporaires
DROP TABLE IF EXISTS "t_freqconf2G";
DROP TABLE IF EXISTS "t_freqconf3G";
DROP TABLE IF EXISTS "t_freqconf4G";


--------------------------------------------------------------------------
--				Requete commentaire format fichier XFREQ				--
--------------------------------------------------------------------------
DROP TABLE IF EXISTS "t_commentaire_L2100";
-- creation table temporaire 2G
CREATE  TABLE "t_commentaire_L2100" AS
     SELECT --case FRGU SRAN16 (RFM2100)
        "t_freqconfglobale"."SBTSId",
        "t_nokia_hw_configorange"."NIDT",
        "t_nokia_hw_configorange"."Configuration_Alias",
        "mapping_conf_l2100"."conf_final",
        "t_nokia_hw_configorange"."btsProfile",
        "mapping_conf_l2100"."profil_final",
        "t_nokia_hw_configorange"."FRGU",
        "t_nokia_hw_configorange"."FRGY",
        "t_freqconfglobale"."freq_config_2g" AS "Config_Initiale_2G",
        "t_freqconfglobale"."freq_config_3g" AS "Config_Initiale_3G",
        "t_freqconfglobale"."freq_config_4g" AS "Config_Initiale_4G",
        "t_nokia_hw_configorange"."FBB_FSM1",
        "t_nokia_hw_configorange"."FBB_FSM2",
        "t_nokia_hw_configorange"."FSMF",
        ------calcul nb FBBC necessaire
        CASE
            WHEN ("mapping_conf_l2100"."profil_final"= 'LWG_2fsm175_4' OR "mapping_conf_l2100"."profil_final"='LWG_2fsm176_4') THEN
                CASE
                    WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800-LTE2600%') THEN (2-"t_nokia_hw_configorange"."FBB_FSM2"::double precision)
                    WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l18'
                    WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE2600%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) -- 'Il faut 1 FBBC mini l26'     
                    WHEN ("t_freqconfglobale"."freq_config_4g" = '-' OR "t_freqconfglobale"."freq_config_4g" = 'LTE800' ) THEN 0
                    ELSE 'NaN'
                END

            WHEN ("mapping_conf_l2100"."profil_final"= 'LWG_2fsm177_4' OR "mapping_conf_l2100"."profil_final"='LWG_2fsm178_4') THEN
                CASE
                    WHEN ("t_freqconfglobale"."freq_config_4g" LIKE '%LTE800%') THEN (2-"t_nokia_hw_configorange"."FBB_FSM2"::double precision) --'Il faut 2 FBBC mini l8**'
                    WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800-LTE2600%' ) THEN (2-"t_nokia_hw_configorange"."FBB_FSM2"::double precision) --'Il faut 2 FBBC mini l18-26**'
                    WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l18**'
                    WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE2600%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l26**'     
                    WHEN ("t_freqconfglobale"."freq_config_4g" = '-') THEN 0
                    ELSE 'NaN'
                END

        END AS "Nb_FBBC",

        CASE
           WHEN "t_nokia_hw_configorange"."FSMF" <=2 THEN (2-"t_nokia_hw_configorange"."FSMF"::double precision)
           ELSE 'NaN'
        END AS "Nb_FSMF"


    FROM
        public."t_freqconfglobale" LEFT JOIN public."t_nokia_hw_configorange"
        ON
            "t_freqconfglobale"."SBTSId" = t_nokia_hw_configorange."SBTSID"       
        LEFT JOIN 
            public."mapping_conf_l2100"
        ON
            "t_nokia_hw_configorange"."Configuration_Alias" = "mapping_conf_l2100"."conf_init"

    WHERE
        "t_nokia_hw_configorange"."FRGU" >0
        AND 
        "t_nokia_hw_configorange"."btsProfile" != 'MRBTS_noProfile'
        AND
        "t_nokia_hw_configorange"."ASIA" = 0
      
UNION

    SELECT --case FRGU SRAN17A (RFM2100)
        "t_freqconfglobale"."SBTSId",
        "t_nokia_hw_configorange"."NIDT",
        "t_nokia_hw_configorange"."Configuration_Alias",
        "t_nokia_hw_configorange"."Configuration_Alias" AS "conf_final",
        "t_nokia_hw_configorange"."btsProfile",
        'MRBTS_noProfile' AS "profil_final",
        "t_nokia_hw_configorange"."FRGU",
        "t_nokia_hw_configorange"."FRGY",
        "t_freqconfglobale"."freq_config_2g" AS "Config_Initiale_2G",
        "t_freqconfglobale"."freq_config_3g" AS "Config_Initiale_3G",
        "t_freqconfglobale"."freq_config_4g" AS "Config_Initiale_4G",
        "t_nokia_hw_configorange"."FBB_FSM1",
        "t_nokia_hw_configorange"."FBB_FSM2",
        "t_nokia_hw_configorange"."FSMF",
        ------calcul nb FBBC necessaire
        CASE
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800-LTE2600%' ) THEN (2-"t_nokia_hw_configorange"."FBB_FSM2"::double precision) --'Il faut 2 FBBC mini l18-26**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l18**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE2600%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l26**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE800' AND ("t_nokia_hw_configorange"."FRGU"::double precision+"t_nokia_hw_configorange"."FRMB"::double precision+"t_nokia_hw_configorange"."FRMF"::double precision)<3 ) THEN 0 --'Il ne faut pas de FBBC'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE800' AND ("t_nokia_hw_configorange"."FRGU"::double precision+"t_nokia_hw_configorange"."FRMB"::double precision+"t_nokia_hw_configorange"."FRMF"::double precision)>3 ) THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut une FBBC (contrainte physique)'
            WHEN ("t_freqconfglobale"."freq_config_4g" = '-') THEN 0
            ELSE 'NaN'             
        END AS "Nb_FBBC",
        ------calcul nb FSMF necessaire
        CASE
           WHEN "t_nokia_hw_configorange"."FSMF" <=2 THEN (2-"t_nokia_hw_configorange"."FSMF"::double precision)
           ELSE 'NaN'
        END AS "Nb_FSMF"


    FROM
        public."t_freqconfglobale" LEFT JOIN public."t_nokia_hw_configorange"
        ON
            "t_freqconfglobale"."SBTSId" = t_nokia_hw_configorange."SBTSID"       
        LEFT JOIN 
            public."mapping_conf_l2100"
        ON
            "t_nokia_hw_configorange"."Configuration_Alias" = "mapping_conf_l2100"."conf_init"

    WHERE
        "t_nokia_hw_configorange"."FRGU" >0
        AND 
        "t_nokia_hw_configorange"."btsProfile" = 'MRBTS_noProfile'
        AND
        "t_nokia_hw_configorange"."ASIA" = 0

UNION

    --case FRGY (RRH2100)
    SELECT 
        "t_freqconfglobale"."SBTSId",
        "t_nokia_hw_configorange"."NIDT",
        "t_nokia_hw_configorange"."Configuration_Alias",
        "mapping_conf_l2100"."conf_final",
        "t_nokia_hw_configorange"."btsProfile",
        'MRBTS_noProfile' AS "profil_final",
        "t_nokia_hw_configorange"."FRGU",
        "t_nokia_hw_configorange"."FRGY",
        "t_freqconfglobale"."freq_config_2g" AS "Config_Initiale_2G",
        "t_freqconfglobale"."freq_config_3g" AS "Config_Initiale_3G",
        "t_freqconfglobale"."freq_config_4g" AS "Config_Initiale_4G",
        "t_nokia_hw_configorange"."FBB_FSM1",
        "t_nokia_hw_configorange"."FBB_FSM2",
        "t_nokia_hw_configorange"."FSMF",
        ------calcul nb FBBC necessaire
        CASE
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800-LTE2600%' ) THEN (2-"t_nokia_hw_configorange"."FBB_FSM2"::double precision) --'Il faut 2 FBBC mini l18-26**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l18**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE2600%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l26**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE800' AND ("t_nokia_hw_configorange"."FRGY"::double precision+"t_nokia_hw_configorange"."FRMB"::double precision+"t_nokia_hw_configorange"."FRMF"::double precision)<3 ) THEN 0 --'Il ne faut pas de FBBC'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE800' AND ("t_nokia_hw_configorange"."FRGY"::double precision+"t_nokia_hw_configorange"."FRMB"::double precision+"t_nokia_hw_configorange"."FRMF"::double precision)>3 ) THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut une FBBC (contrainte physique)'
            WHEN ("t_freqconfglobale"."freq_config_4g" = '-') THEN 0
            ELSE 'NaN'
        END AS "Nb_FBBC",

        CASE
           WHEN "t_nokia_hw_configorange"."FSMF" <=2 THEN (2-"t_nokia_hw_configorange"."FSMF"::double precision)
           ELSE 'NaN'
        END AS "Nb_FSMF"


    FROM
        public."t_freqconfglobale" LEFT JOIN public."t_nokia_hw_configorange"
        ON
            "t_freqconfglobale"."SBTSId" = t_nokia_hw_configorange."SBTSID"       
        LEFT JOIN 
            public."mapping_conf_l2100"
        ON
            "t_nokia_hw_configorange"."Configuration_Alias" = "mapping_conf_l2100"."conf_init"

    WHERE
        "t_nokia_hw_configorange"."FRGY" >0
        AND
        "t_nokia_hw_configorange"."ASIA" = 0

UNION

    --case 2100 (FRGY & FRGU) sur Airscale (A finir)
    SELECT 
        "t_freqconfglobale"."SBTSId",
        "t_nokia_hw_configorange"."NIDT",
        "t_nokia_hw_configorange"."Configuration_Alias",
        "t_nokia_hw_configorange"."Configuration_Alias" AS "conf_final",
        "t_nokia_hw_configorange"."btsProfile",
        'MRBTS_noProfile' AS "profil_final",
        "t_nokia_hw_configorange"."FRGU",
        "t_nokia_hw_configorange"."FRGY",
        "t_freqconfglobale"."freq_config_2g" AS "Config_Initiale_2G",
        "t_freqconfglobale"."freq_config_3g" AS "Config_Initiale_3G",
        "t_freqconfglobale"."freq_config_4g" AS "Config_Initiale_4G",
        "t_nokia_hw_configorange"."FBB_FSM1",
        "t_nokia_hw_configorange"."FBB_FSM2",
        "t_nokia_hw_configorange"."FSMF",
        ------calcul nb FBBC necessaire
        /*CASE
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800-LTE2600%' ) THEN (2-"t_nokia_hw_configorange"."FBB_FSM2"::double precision) --'Il faut 2 FBBC mini l18-26**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE1800%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l18**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE2600%') THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut 1 FBBC mini l26**'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE800' AND ("t_nokia_hw_configorange"."FRGY"::double precision+"t_nokia_hw_configorange"."FRMB"::double precision+"t_nokia_hw_configorange"."FRMF"::double precision)<3 ) THEN 0 --'Il ne faut pas de FBBC'
            WHEN ("t_freqconfglobale"."freq_config_4g" LIKE 'LTE800' AND ("t_nokia_hw_configorange"."FRGY"::double precision+"t_nokia_hw_configorange"."FRMB"::double precision+"t_nokia_hw_configorange"."FRMF"::double precision)>3 ) THEN GREATEST((1-"t_nokia_hw_configorange"."FBB_FSM2"::double precision),0) --'Il faut une FBBC (contrainte physique)'
            WHEN ("t_freqconfglobale"."freq_config_4g" = '-') THEN 0
            ELSE 'NaN'
        END AS "Nb_FBBC",*/
        0 AS "Nb_FBBC",
		0 AS "Nb_FSMF"


    FROM
        public."t_freqconfglobale" LEFT JOIN public."t_nokia_hw_configorange"
        ON
            "t_freqconfglobale"."SBTSId" = t_nokia_hw_configorange."SBTSID"       
        LEFT JOIN 
            public."mapping_conf_l2100"
        ON
            "t_nokia_hw_configorange"."Configuration_Alias" = "mapping_conf_l2100"."conf_init"

    WHERE
        "t_nokia_hw_configorange"."ASIA" > 0
        AND
        ("t_nokia_hw_configorange"."FRGU"::double precision + "t_nokia_hw_configorange"."FRGY"::double precision)>0


GROUP BY
    "t_freqconfglobale"."SBTSId",
    "t_nokia_hw_configorange"."NIDT",
    "t_nokia_hw_configorange"."Configuration_Alias",
    "conf_final",
    "t_nokia_hw_configorange"."btsProfile",
    "profil_final",
    "t_nokia_hw_configorange"."FRGU",
    "t_nokia_hw_configorange"."FRGY",
    "Config_Initiale_2G",
    "Config_Initiale_3G",
    "Config_Initiale_4G",
    "t_nokia_hw_configorange"."FBB_FSM1",
    "t_nokia_hw_configorange"."FBB_FSM2",
    "t_nokia_hw_configorange"."FSMF",
    "Nb_FBBC",
    "Nb_FSMF"

    

ORDER BY 
	"SBTSId",
    "NIDT";
        

--------------------------------------------------------------------------
--				Requete commentaire 									--
--------------------------------------------------------------------------
DROP TABLE IF EXISTS "t_commentaire_final";
CREATE  TABLE "t_commentaire_final" AS
SELECT
        "t_commentaire_L2100"."SBTSId",
        "t_commentaire_L2100"."NIDT",
        "t_commentaire_L2100"."Configuration_Alias",
		"t_commentaire_L2100"."conf_final",
		"t_commentaire_L2100"."btsProfile",
        "t_commentaire_L2100"."profil_final",
        "t_commentaire_L2100"."Config_Initiale_2G",
        "t_commentaire_L2100"."Config_Initiale_3G",
        "t_commentaire_L2100"."Config_Initiale_4G",
        CASE
            WHEN CONCAT("t_commentaire_L2100"."profil_final",'-',"t_commentaire_L2100"."conf_final") = '-' THEN
            	'-'
            ELSE
                 CONCAT(
                     CASE
                        WHEN "t_commentaire_L2100"."btsProfile" LIKE 'LWG_2fsm17%_3' THEN 
                            '[Programme 2018] Ajout de LTE2100 sur site Nokia (HW READY)'||E'\n'
                        ELSE
                            '[Programme 2018] Ajout de LTE2100 sur site Nokia'||E'\n'
                     END,
                     'Passage de la configuration HW ',
                     "t_commentaire_L2100"."Configuration_Alias",            
                     ' à ',
                     "t_commentaire_L2100"."conf_final",
                     CASE
                     	WHEN "t_commentaire_L2100"."FRGY" >0 THEN ' (MRBTS_noProfile = plus de profil car opération avec RRH2100 nécessitant SRAN17A)'||E'\n' -- cas RRH2100 FRGY
                     	WHEN ("t_commentaire_L2100"."FRGU" >0 AND "t_commentaire_L2100"."profil_final" ='MRBTS_noProfile') THEN ' (MRBTS_noProfile = plus de profil car opération réalisé sur SRAN17A)'||E'\n' -- cas RFM2100 en SRAN17A
                     	ELSE
                         CONCAT(' (Profil ',
                         "t_commentaire_L2100"."btsProfile", 
                         ' => ',
                         "t_commentaire_L2100"."profil_final",')'||E'\n')
                     END,
                     CASE
                          -- cas avec U900
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" = 'FDD10' THEN 'Pas de modification de la bande U2100 : FDD10 only'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" = 'FDD10-FDD11' THEN 'Modification de la bande U2100 : FDD10-11 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" = 'FDD10-FDD11-FDD7' THEN 'Modification de la bande U2100 : FDD10-11 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" = 'FDD10-FDD11-FDD12' THEN 'Modification de la bande U2100 : FDD10-11-12 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" = 'FDD10-FDD11-FDD12-FDD7' THEN 'Modification de la bande U2100 : FDD10-11-12-7 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" = 'FDD10-FDD7' THEN 'Pas de mofication U2100 : conf déja cible FDD10-7'
                          -- cas avec U900
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" LIKE 'FDD10-U%' THEN 'Pas de modification de la bande U2100 : FDD10 only'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" LIKE 'FDD10-FDD11-U%' THEN 'Modification de la bande U2100 : FDD10-11 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" LIKE 'FDD10-FDD11-FDD7-U%' THEN 'Modification de la bande U2100 : FDD10-11 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" LIKE 'FDD10-FDD11-FDD12-U%' THEN 'Modification de la bande U2100 : FDD10-11-12 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" LIKE 'FDD10-FDD11-FDD12-FDD7-U%' THEN 'Modification de la bande U2100 : FDD10-11-12-7 à FDD10-7'
                          WHEN "t_commentaire_L2100"."Config_Initiale_3G" LIKE 'FDD10-FDD7-U%' THEN 'Pas de mofication U2100 : conf déja cible FDD10-7'
                          ELSE 'Error'
                      END,
                     CASE
                     	WHEN "t_commentaire_L2100"."profil_final" ='MRBTS_noProfile' THEN
                              CASE 
                                  WHEN "t_commentaire_L2100"."FRGU"= 1 THEN E'\n'||E'\n'||'L''operation consiste à rajouter le L2100 en réutilisant le module FRGU déjà installé'||E'\n (Ajout d''une fibre + recablage sur la FSMF LTE nécessaire)\n'
                                  WHEN "t_commentaire_L2100"."FRGY"= 1 THEN E'\n'||E'\n'||'L''operation consiste à rajouter le L2100 en réutilisant le module FRGY déjà installé'||E'\n(recablage sur la FSMF LTE nécessaire)\n'
                                  WHEN "t_commentaire_L2100"."FRGY"= 2 THEN E'\n'||E'\n'||'L''operation consiste à rajouter le L2100 en réutilisant les 2 modules FRGY déjà installé'||E'\n(recablage sur la FSMF LTE nécessaire)\n'
                                  WHEN "t_commentaire_L2100"."FRGY"= 3 THEN E'\n'||E'\n'||'L''operation consiste à rajouter le L2100 en réutilisant les 3 modules FRGY déjà installé'||E'\n(recablage sur la FSMF LTE nécessaire)\n'
                              END
                     	ELSE
                     		CASE 
                                  WHEN "t_commentaire_L2100"."FRGU"= 1 THEN E'\n'||E'\n'||'L''operation consiste à rajouter le L2100 en réutilisant le module FRGU déjà installé'||E'\n'
                              END
						END,
                      CASE
                        WHEN ("t_commentaire_L2100"."Nb_FSMF" >0 AND "t_commentaire_L2100"."Nb_FBBC" >0) THEN 'HW nécessaires : '||E'\n'||'[ Ajouter' || "t_commentaire_L2100"."Nb_FSMF"||' FSMF, ' ||"t_commentaire_L2100"."Nb_FBBC"|| 'FBBC ]'
                        WHEN ("t_commentaire_L2100"."Nb_FSMF" >0)  THEN 'HW nécessaire : '||E'\n'||'[ Ajouter ' || "t_commentaire_L2100"."Nb_FSMF"||' FSMF ]'
                        WHEN ("t_commentaire_L2100"."Nb_FBBC" >0) THEN 'HW nécessaire : '||E'\n'||'[ Ajouter '||"t_commentaire_L2100"."Nb_FBBC"|| ' FBBC ]'
                      END
                    ) 
                   END AS "Commentaire_Swan",     
                   "t_commentaire_L2100"."Nb_FBBC",
                   "t_commentaire_L2100"."Nb_FSMF"

    FROM
        public."t_commentaire_L2100"

