DROP TABLE IF EXISTS t_noria_topo_3g;

CREATE TABLE t_noria_topo_3g AS
SELECT
  min(noria_celluleumts_reel."NOM") AS "NOM", 
  noria_celluleumts_reel."IDRESEAUCELLULE",
  min(noria_celluleumts_reel."BANDE") AS "BANDE", 
  min(noria_celluleumts_reel."ETAT_DEPL") AS "ETAT_DEPL",
  min(noria_celluleumts_reel."ETAT_FONCT") AS "ETAT_FONCT",
  min(noria_celluleumts_reel."GN") AS "GN", 
  min(noria_site."X") AS "X", 
  min(noria_site."Y") AS "Y", 
  min(noria_3g_xpolar."CAT_REF") AS "CAT_REF", 
  min(noria_3g_xpolar."AZIMUT") AS "AZIMUT", 
  min(noria_3g_xpolar."TILT_MECANIQUE") AS "TILT_MECANIQUE", 
  min(noria_3g_xpolar."HAUTEUR_BAS_ANTENNE") AS "HAUTEUR_SOL", 
  min(noria_3g_xpolar."HAUTEUR_BAS_SUPPORT") AS "HAUTEUR_BAS_SUPPORT", 
  min(noria_3g_xpolar."TILT_ELECTRIQUE_UMTS2200") AS "TILT_ELECTRIQUE_UMTS2200", 
  min(noria_3g_xpolar."TILT_ELECTRIQUE_UMTS900") AS "TILT_ELECTRIQUE_UMTS900",
  min(noria_3g_xpolar."PERTES_P2_UMTS2200_MAIN") AS "PERTES_P2_UMTS2200_MAIN",
  min(noria_3g_xpolar."PERTES_P2_UMTS2200_DIV") AS "PERTES_P2_UMTS2200_DIV",
  min(noria_3g_xpolar."PERTES_P2_UMTS900_MAIN") AS "PERTES_P2_UMTS900_MAIN",
  min(noria_3g_xpolar."PERTES_P2_UMTS900_DIV") AS "PERTES_P2_UMTS900_DIV"
  
FROM  
  public.noria_celluleumts_reel LEFT JOIN public.noria_3g_xpolar
  ON 
	noria_celluleumts_reel."ID_NORIA_CELL" = noria_3g_xpolar."ID_NORIA_CELL"
  INNER JOIN public.noria_candidat
  ON 
	noria_celluleumts_reel."GN" = noria_candidat."GN" AND
	noria_celluleumts_reel."CANDIDAT" = noria_candidat."CANDIDAT"
  INNER JOIN public.noria_site
  ON
	noria_candidat."CODESITE" = noria_site."CODE_SITE"
WHERE
  noria_celluleumts_reel."CONSTRUCTEUR" NOT IN ('COMMSCOPE','ANDREW','SELECOM')
  AND noria_celluleumts_reel."NOM" NOT LIKE 'REP_%'
  --AND noria_celluleumts_reel."GN" LIKE '%267J2%'
GROUP BY
  noria_celluleumts_reel."IDRESEAUCELLULE"
;
