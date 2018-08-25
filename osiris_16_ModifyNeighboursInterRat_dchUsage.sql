SELECT 
  *,
  'sib11OrDchUsage' AS parametre,
  CASE 	WHEN (row_number <= 12) THEN 'sib11AndDch'
          ELSE 'dchUsage' END 
	AS valeur

FROM 
  public.osiris_fluxctn3g2g_interrat	 
WHERE 
 (
 "VOIS" = '1' 
 AND row_number <= 32
 )
 OR  --Liste des voisines qu'on a accepte de rajouter :
 ("VOIS" = '0'   --Voisine non declaree
 AND row_number <= 32 --Doit faire partie des 32 meilleures voisines
 AND ho_att_total > 5  --Doit etre superieur a un nombre minimal
 AND distance < 40000 -- distance maximale a respecter)
 )
 
 ORDER BY
  "NOM_S" ASC,
  row_number ASC
;
