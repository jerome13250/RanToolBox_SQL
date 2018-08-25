SELECT *
FROM 
  public.osiris_fluxctn3g2g_interrat 
	 
WHERE 
 "VOIS" = '0'   --Voisine non declaree
 AND row_number <= 32 --Doit faire partie des 32 meilleures voisines
 AND ho_att_total > 5  --Doit etre superieur a un nombre minimal
 AND distance < 40000 -- distance maximale a respecter

 ORDER BY
  --"NOM_S" ASC,
  ho_att_total DESC
;
