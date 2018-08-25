SELECT 
  t_voisines3g3g.*,
  nbsho1.nbshoplusdetected AS nbshoplusdetected,
  nbsho2.nbshoplusdetected AS nbshoplusdetected_inv
FROM 
  public.t_voisines3g3g
  LEFT JOIN public.t_ctn_autoplan_sho_limit31 
    ON
    t_ctn_autoplan_sho_limit31.fddcell = t_voisines3g3g.fddcell AND
    t_voisines3g3g.umtsfddneighbouringcell = t_ctn_autoplan_sho_limit31.umtsfddneighbouringcell
  LEFT JOIN public.t_ctn_autoplan_nbshoplusdetected AS nbsho1
    ON
    t_voisines3g3g.fddcell = nbsho1.fddcell AND
    t_voisines3g3g.umtsfddneighbouringcell = nbsho1.umtsfddneighbouringcell
  LEFT JOIN public.t_ctn_autoplan_nbshoplusdetected AS nbsho2
    ON
    t_voisines3g3g.fddcell = nbsho2.umtsfddneighbouringcell AND
    t_voisines3g3g.umtsfddneighbouringcell = nbsho2.fddcell
   
WHERE 
  t_ctn_autoplan_sho_limit31.fddcell IS NULL
  AND t_voisines3g3g.dlfrequencynumber_s = t_voisines3g3g.dlfrequencynumber_v -- Voisines INTRAFREQ seulement
  AND t_voisines3g3g.fddcell IN ( 
	SELECT DISTINCT fddcell 
	FROM public.t_ctn_autoplan_sho_limit31 -- Permet de ne toucher que les cellules qui ont ete dans la trace
	WHERE t_ctn_autoplan_sho_limit31.operationalstates <> 'disabled' -- Permet de ne pas prendre en compte les primarycell qui sont HS
	)
  -- IL FAUT RAJOUTER UNE CONDITION POUR NE PAS SUPPRIMER LES VOISINES RAN SHARING declarees sib11only avec un detected > 0
ORDER BY 
  t_voisines3g3g.fddcell,
  t_voisines3g3g.umtsfddneighbouringcell
;
