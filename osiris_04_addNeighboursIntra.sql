--Cette requete sert a ajouter les voisines INTRAFREQ pour atteindre le plan ideal
SELECT 
  public.osiris_fluxctn3g3g_intrafreq.*,
  'A' AS OPERATION  
FROM 
  public.osiris_fluxctn3g3g_intrafreq
WHERE 
	osiris_fluxctn3g3g_intrafreq."VOIS" = '0' -- La voisine n'est pas declaree
	AND row_number <= 31 --Ajoute les voisines superieures a 31
 ;
