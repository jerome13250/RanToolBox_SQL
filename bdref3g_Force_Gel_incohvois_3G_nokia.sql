--cette requête permet de forcer le Gel en zone Nokia sur des cellules avec uniquement des Ajouts de voisines (typiquement les extensions)
UPDATE public.bdref_visuincohtopo_vois_nokia
SET "Etats" = 'OK'
WHERE 
	"Etats" != 'OK' --je ne modifie pas ceux qui sont déja OK
	AND
	"LCIDs" NOT IN ( --je cherche toutes les voisines en cours d'ajout où on ne demande pas de suppression en zone gelée ou reparenting
	SELECT DISTINCT 
	  bdref_visuincohtopo_vois_nokia."LCIDs"
	FROM 
	  public.bdref_visuincohtopo_vois_nokia
	WHERE
	  "Etats" IN ('gelée','Reparenting') AND
	  "Opération" ILIKE 'S%'
	)

;
	
