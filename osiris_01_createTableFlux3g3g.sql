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


DROP TABLE IF EXISTS osiris_fluxctn3g3g_numeric;

CREATE TABLE osiris_fluxctn3g3g_numeric AS

SELECT 
  osiris_fluxctn3g3g."RNC_S", 
  osiris_fluxctn3g3g."LCID_S", 
  osiris_fluxctn3g3g."LAC_S", 
  osiris_fluxctn3g3g."NOM_S",
  osiris_fluxctn3g3g."BANDE_S", 
  osiris_fluxctn3g3g."NIDT_S", 
  osiris_fluxctn3g3g."TECHNO_S", 
  osiris_fluxctn3g3g."Plaque_S", 
  osiris_fluxctn3g3g."RNC_V", 
  osiris_fluxctn3g3g."LCID_V", 
  osiris_fluxctn3g3g."LAC_V", 
  osiris_fluxctn3g3g."NOM_V", 
  osiris_fluxctn3g3g."BANDE_V",
  t_topologie3g.administrativestate AS administrativestate_v,
  t_topologie3g.operationalstate AS operationalstate_v, 
  osiris_fluxctn3g3g."NIDT_V", 
  osiris_fluxctn3g3g."TECHNO_V", 
  osiris_fluxctn3g3g."Plaque_V", 
  osiris_fluxctn3g3g."Vol(%)", 
  osiris_fluxctn3g3g."HO_SUCC_TOTAL", 
  osiris_fluxctn3g3g."HO_ATT_TOTAL", 
  osiris_fluxctn3g3g."HO_Exec_SR(%)", 
  osiris_fluxctn3g3g."HO_FAIL_TOTAL", 
  osiris_fluxctn3g3g."HO_DETECTED", 
  osiris_fluxctn3g3g."VOIS", 
  osiris_fluxctn3g3g."SIB11ANDDCH", 
  osiris_fluxctn3g3g."Distance(m)",
  CASE WHEN ("NIDT_S"="NIDT_V" OR (operationalstate = 'disabled' AND "VOIS"='1')) THEN castnumeric("HO_ATT_TOTAL") + 1000000 --Cas ou on est cosecteur ou cellule voisine offline
	ELSE castnumeric("HO_ATT_TOTAL") END AS ho_att_total,
  castnumeric("HO_DETECTED") AS ho_detected,
  castnumeric("Distance(m)") AS distance
FROM 
  public.osiris_fluxctn3g3g LEFT JOIN public.t_topologie3g
  ON 
    osiris_fluxctn3g3g."LCID_V" = t_topologie3g.localcellid
  
WHERE "NOM_S" <> '' --Supprime les lignes avec voisines sans topologie Osiris, comme CAVAILLON_GDE_BASTIDE_W19 et 29
      --AND "NOM_S" = 'MOURIES_U11' --TEMPORAIRE POUR TEST

ORDER BY
 osiris_fluxctn3g3g."NOM_S",
 ho_att_total DESC,
 distance DESC


;
