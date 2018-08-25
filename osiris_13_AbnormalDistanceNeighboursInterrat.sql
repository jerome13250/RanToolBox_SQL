SELECT *
FROM 
  public.osiris_fluxctn3g2g_interrat 
	 
WHERE 
 "VOIS" = '1'   --Voisine declaree
 
 AND distance > 40000 -- distance maximale a respecter
 AND ("NIDT_S" LIKE '%V1' OR "NIDT_V" LIKE '%V1')

 ORDER BY
  --"NOM_S" ASC,
  distance DESC
;
