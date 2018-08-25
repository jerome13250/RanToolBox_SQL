SELECT 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."NIDT_S", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."Plaque_S", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.nodeb, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.sector_number, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.fddcell, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.dlfrequencynumber, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.localcellid, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."RNC_V", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."LCID_V", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."LAC_V", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."NOM_V", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."BANDE_V", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.administrativestate_v, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.operationalstate_v, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."NIDT_V", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."Plaque_V", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."Vol(%)", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."HO_SUCC_TOTAL", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."HO_ATT_TOTAL", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."HO_Exec_SR(%)", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."HO_FAIL_TOTAL", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."HO_DETECTED", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."VOIS", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."SIB11ANDDCH", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900."Distance(m)", 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.ho_att_total, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.ho_detected, 
  osiris_fluxctn_fdd111207_cloningfdd10_u900.distance
FROM 
  public.osiris_fluxctn_fdd111207_cloningfdd10_u900 LEFT JOIN public.t_voisines3g3g
	ON
	osiris_fluxctn_fdd111207_cloningfdd10_u900.localcellid = t_voisines3g3g.localcellid_s AND
	osiris_fluxctn_fdd111207_cloningfdd10_u900."LCID_V" = t_voisines3g3g.localcellid_v
WHERE 
	t_voisines3g3g.localcellid_s IS NULL
	--AND osiris_fluxctn_fdd111207_cloningfdd10_u900."NIDT_S" LIKE '%V1'
ORDER BY
	ho_att_total DESC

;
