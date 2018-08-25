SELECT 
  "LCIDs", 
  "NOMs", 
  "LCIDv", 
  "NOMv", 
  "CLASSEs", 
  "CLASSEv", 
  "Etats", 
  "Etatv", 
  'S'::text AS "Operation",
  CASE 
	WHEN "NOMs" = '' THEN 'Serveuse inconnue'::text
	WHEN "NOMv" = '' THEN 'Voisine inconnue'::text
	WHEN "NOMv" = 'EXTERNE' THEN 'Voisine EXTERNE'::text
	END AS commentaire
	
FROM 
  public.bdref_visuincohtopo_vois_nokia
WHERE
  "Opération" ILIKE 'A%' AND
  (
	"NOMs" = '' OR --Serveuse inconnue
	"NOMv" = '' OR
	"NOMv" = 'EXTERNE'
  );
