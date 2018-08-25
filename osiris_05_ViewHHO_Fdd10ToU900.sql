SELECT 
  * 
FROM 
  public.osiris_fluxctn3g3g_numeric
WHERE 
  osiris_fluxctn3g3g_numeric."BANDE_S" = 'FDD10' AND 
  osiris_fluxctn3g3g_numeric."BANDE_V" = 'UMTS900' 
  AND   "VOIS"='0' 
  AND   osiris_fluxctn3g3g_numeric."NIDT_S" LIKE '%V1'
ORDER BY ho_att_total DESC
;
