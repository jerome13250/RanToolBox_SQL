DROP TABLE IF EXISTS t_noria_topo_3g;

CREATE TABLE t_noria_topo_3g AS

SELECT 
  atoll_emetteurs_3g."Emetteur" AS "NOM", 
  atoll_emetteurs_3g."LocalCID" AS "IDRESEAUCELLULE", 
  atoll_emetteurs_3g."Site" AS "GN", 
  atoll_sites."X", 
  atoll_sites."Y", 
  atoll_emetteurs_3g."Antenne" AS "CAT_REF", 
  atoll_emetteurs_3g."Azimut (°)" AS "AZIMUT", 
  atoll_emetteurs_3g."Downtilt mécanique (°)" AS "TILT_MECANIQUE", 
  atoll_emetteurs_3g."Hauteur (m)" AS "HAUTEUR_SOL",
  '' AS "HAUTEUR_BAS_SUPPORT", 
  '' AS "TILT_ELECTRIQUE_UMTS2200", 
  '' AS "TILT_ELECTRIQUE_UMTS900"
FROM 
  public.atoll_emetteurs_3g, 
  public.atoll_sites
WHERE 
  atoll_emetteurs_3g."Site" = atoll_sites."Nom"
  
  ORDER BY
  atoll_emetteurs_3g."Emetteur" ASC;
