DROP TABLE IF EXISTS osiris_fluxctn_fdd111207_Cloningfdd10_U900;

CREATE TABLE osiris_fluxctn_fdd111207_Cloningfdd10_U900 AS


SELECT DISTINCT
  osiris_fluxctn3g3g_numeric."RNC_S", 
  osiris_fluxctn3g3g_numeric."LCID_S", 
  osiris_fluxctn3g3g_numeric."NOM_S", 
  osiris_fluxctn3g3g_numeric."BANDE_S", 
  osiris_fluxctn3g3g_numeric."Plaque_S", 
  osiris_fluxctn3g3g_numeric."NIDT_S", 
  osiris_fluxctn3g3g_numeric."LAC_S", 
  topo2.nodeb, 
  topo2.sector_number, 
  topo2.fddcell, 
  topo2.dlfrequencynumber, 
  topo2.localcellid, 
  osiris_fluxctn3g3g_numeric."RNC_V", 
  osiris_fluxctn3g3g_numeric."LCID_V", 
  osiris_fluxctn3g3g_numeric."LAC_V", 
  osiris_fluxctn3g3g_numeric."NOM_V", 
  osiris_fluxctn3g3g_numeric."BANDE_V", 
  osiris_fluxctn3g3g_numeric.administrativestate_v, 
  osiris_fluxctn3g3g_numeric.operationalstate_v, 
  osiris_fluxctn3g3g_numeric."NIDT_V", 
  osiris_fluxctn3g3g_numeric."Plaque_V", 
  osiris_fluxctn3g3g_numeric."Vol(%)", 
  osiris_fluxctn3g3g_numeric."HO_SUCC_TOTAL", 
  osiris_fluxctn3g3g_numeric."HO_ATT_TOTAL", 
  osiris_fluxctn3g3g_numeric."HO_Exec_SR(%)", 
  osiris_fluxctn3g3g_numeric."HO_FAIL_TOTAL", 
  osiris_fluxctn3g3g_numeric."HO_DETECTED", 
  osiris_fluxctn3g3g_numeric."VOIS", 
  osiris_fluxctn3g3g_numeric."SIB11ANDDCH", 
  osiris_fluxctn3g3g_numeric."Distance(m)", 
  osiris_fluxctn3g3g_numeric.ho_att_total, 
  osiris_fluxctn3g3g_numeric.ho_detected, 
  osiris_fluxctn3g3g_numeric.distance
FROM 
  public.osiris_fluxctn3g3g_numeric INNER JOIN public.t_topologie3g topo1
	ON osiris_fluxctn3g3g_numeric."LCID_S" = topo1.localcellid
  INNER JOIN public.t_topologie3g topo2
	ON   topo1.nodeb = topo2.nodeb AND
	     topo1.sector_number = topo2.sector_number
WHERE 
  osiris_fluxctn3g3g_numeric."BANDE_S"='FDD10' AND
  osiris_fluxctn3g3g_numeric."BANDE_V"='UMTS900' AND
  osiris_fluxctn3g3g_numeric.ho_att_total > 0 AND 
  topo2.dlfrequencynumber IN ('10812','10836','10712')

;
