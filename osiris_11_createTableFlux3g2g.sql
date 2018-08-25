CREATE OR REPLACE FUNCTION castnumeric(text) RETURNS NUMERIC AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN x;
EXCEPTION WHEN others THEN
    RETURN 0;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;


DROP TABLE IF EXISTS osiris_fluxctn3g2g_numeric;

CREATE TABLE osiris_fluxctn3g2g_numeric AS

SELECT 
  osiris_fluxctn3g2g."RNC_S", 
  osiris_fluxctn3g2g."LCID_S", 
  osiris_fluxctn3g2g."LAC_S", 
  osiris_fluxctn3g2g."NOM_S",
  osiris_fluxctn3g2g."BANDE_S", 
  osiris_fluxctn3g2g."NIDT_S", 
  osiris_fluxctn3g2g."TECHNO_S", 
  osiris_fluxctn3g2g."Plaque_S", 
  osiris_fluxctn3g2g."BSC_V", 
  osiris_fluxctn3g2g."CI_V", 
  osiris_fluxctn3g2g."LAC_V", 
  osiris_fluxctn3g2g."NOM_V", 
  osiris_fluxctn3g2g."BANDE_V",
  osiris_fluxctn3g2g."NIDT_V", 
  osiris_fluxctn3g2g."TECHNO_V", 
  osiris_fluxctn3g2g."Plaque_V", 
  osiris_fluxctn3g2g."Vol(%)", 
  osiris_fluxctn3g2g."HO_SUCC_TOTAL", 
  osiris_fluxctn3g2g."HO_ATT_TOTAL", 
  osiris_fluxctn3g2g."HO_SR(%)", 
  osiris_fluxctn3g2g."VOIS", 
  osiris_fluxctn3g2g."SIB11ANDDCH", 
  osiris_fluxctn3g2g."Distance(m)",
  CASE WHEN ("NIDT_S"="NIDT_V") THEN castnumeric("HO_ATT_TOTAL") + 1000000 --Cas ou on est cosecteur
	ELSE castnumeric("HO_ATT_TOTAL") END AS ho_att_total,
  castnumeric("Distance(m)") AS distance
FROM 
  public.osiris_fluxctn3g2g
  
WHERE "NOM_S" <> '' --Supprime les lignes avec voisines sans topologie Osiris, comme CAVAILLON_GDE_BASTIDE_W19 et 29
      --AND "NOM_S" = 'MOURIES_U11' --TEMPORAIRE POUR TEST

ORDER BY
 osiris_fluxctn3g2g."NOM_S",
 ho_att_total DESC,
 distance DESC


;
