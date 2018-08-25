SELECT *
FROM 
  public.osiris_fluxctn3g2g_interrat 
	
  
WHERE 
 row_number > 32

 ORDER BY
  "NOM_S" ASC,
  ho_att_total DESC
;
