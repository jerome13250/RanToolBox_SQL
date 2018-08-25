-- Cette requete sert a creer le plan de voisines INTRAFREQ ideal calcule avec les flux
DROP TABLE IF EXISTS osiris_fluxctn3g3g_intrafreq;

CREATE TABLE osiris_fluxctn3g3g_intrafreq AS

SELECT 
  *,
  ho_att_total + ho_detected/20 AS ranknote,
  row_number() OVER (PARTITION BY "NOM_S" ORDER BY ho_att_total + ho_detected/20 DESC, distance ASC) AS row_number
FROM 
  public.osiris_fluxctn3g3g_numeric
WHERE 
  "BANDE_S" = "BANDE_V" -- INTRAFREQ seulement
  AND "BANDE_S" IN ('FDD10','UMTS900') -- Les CTN ne sont representatifs que sur le CS donc FDD10 et UMTS900
  AND NOT (ho_att_total = 0 AND "VOIS"='0' AND distance>5000)  -- Permet de ne selectionner que les pures detected tres proches (5000m) car il y a sinon trop d'ambiguites
  AND NOT (ho_att_total + ho_detected/20 < 20 AND "VOIS"='0') --Permet de supprimer les voisines non declarees mais faibles flux
  AND ho_att_total + ho_detected/20 > 0 --Supprime les voisines inutiles avec 0 flux (ATTENTION a modifier les valeurs des Offlines)
;
