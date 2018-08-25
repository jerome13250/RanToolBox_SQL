DROP TABLE IF EXISTS t_ctn_autoplan_nbshoplusdetected;

CREATE TABLE t_ctn_autoplan_nbshoplusdetected AS

SELECT 
	fddcell, 
	umtsfddneighbouringcell, 
	sum(nbshoplusdetected) AS nbshoplusdetected

FROM

(SELECT -- Donne les HO par NEIGHBOR ou CTN
  t_ctn_result_sho.fddcell, 
  t_ctn_result_sho.umtsfddneighbouringcell, 
  t_ctn_result_sho.nb_ho3g3gsuccess AS nbshoplusdetected 
FROM 
  public.t_ctn_result_sho

UNION

SELECT -- Donne les HO estimation par DETECTED, je mets un facteur 20 (20 detected pour faire un SHO normal)
  t_ctn_result_detected.fddcell, 
  t_ctn_result_detected.umtsfddneighbouringcell, 
  t_ctn_result_detected.nb_event/20 AS nbshoplusdetected 
FROM 
  public.t_ctn_result_detected

UNION

(SELECT -- Mets 1 million pour les HO vers des cellules Hors service
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  1000000 AS nbshoplusdetected 
FROM 
  public.t_voisines3g3g 
  JOIN public.t_topologie3g
  ON
	t_voisines3g3g.umtsfddneighbouringcell = t_topologie3g.fddcell 
WHERE 
  t_topologie3g.operationalstate = 'disabled'
  AND t_voisines3g3g.fddcell IN ( 
	SELECT DISTINCT fddcell 
	FROM public.t_ctn_result_sho) )

 ) AS temp


  

GROUP BY

	fddcell, 
	umtsfddneighbouringcell

ORDER BY 
	fddcell, 
	nbshoplusdetected DESC

;
