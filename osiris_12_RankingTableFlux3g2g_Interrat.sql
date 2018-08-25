-- Cette requete sert a creer le plan de voisines INTRAFREQ ideal calcule avec les flux
DROP TABLE IF EXISTS osiris_fluxctn3g2g_interrat;

CREATE TABLE osiris_fluxctn3g2g_interrat AS

SELECT 
  *,
  row_number() OVER (PARTITION BY "NOM_S" ORDER BY ho_att_total DESC, distance ASC) AS row_number
FROM 
  public.osiris_fluxctn3g2g_numeric
WHERE 
  "BANDE_S" IN ('FDD10','UMTS900') -- Les CTN ne sont representatifs que sur le CS donc FDD10 et UMTS900
;
