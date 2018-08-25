SELECT 
  t_voisines3g3g_bdref.rnc, 
  t_voisines3g3g_bdref.rncid_s, 
  t_voisines3g3g_bdref.nodeb_s, 
  t_voisines3g3g_bdref.fddcell, 
  t_voisines3g3g_bdref.dlfrequencynumber_s, 
  t_voisines3g3g_bdref.localcellid_s AS LCIDS, 
  t_voisines3g3g_bdref.classe_s, 
  t_voisines3g3g_bdref.rnc_v, 
  t_voisines3g3g_bdref.rncid_v, 
  t_voisines3g3g_bdref.nodeb_v, 
  t_voisines3g3g_bdref.umtsfddneighbouringcell, 
  t_voisines3g3g_bdref.dlfrequencynumber_v, 
  t_voisines3g3g_bdref.localcellid_v  AS LCIDV, 
  t_voisines3g3g_bdref.sib11ordchusage AS omc_sib11ordchusage,
  'sib11OrDchUsage' AS parametre,
  'dchUsage' AS valeur,
  'suppression sib11' AS commentaire
  FROM 
  public.t_voisines3g3g_bdref 
WHERE 
  t_voisines3g3g_bdref.sib11ordchusage = 'sib11AndDch'
  AND (
    --Cas Cosite et non Hotspot :
    (t_voisines3g3g_bdref.nodeb_s = t_voisines3g3g_bdref.nodeb_v  --Cosite
     AND t_voisines3g3g_bdref.classe_s NOT LIKE '%HotSpot' --On a pas de classe Hotspot
    )
    --Cas Non cosite
    OR (t_voisines3g3g_bdref.nodeb_s != t_voisines3g3g_bdref.nodeb_v) --Pas Cosite
  )

  AND --Liste des frequences interdites en sib11 
  (
	( dlfrequencynumber_s = '10787' AND dlfrequencynumber_v IN ('10812','10836','10712')) --CAS FDD10 Vers 11-12-7
	OR ( dlfrequencynumber_s = '10812' AND dlfrequencynumber_v IN ('10836','10712')) --CAS FDD11 Vers 12-7
	OR ( dlfrequencynumber_s = '10836' AND dlfrequencynumber_v IN ('10812','10712')) --CAS FDD12 Vers 11-7
	OR ( dlfrequencynumber_s = '10712' AND dlfrequencynumber_v IN ('10812','10836')) --CAS FDD7 Vers 11-12
  )
ORDER BY
  t_voisines3g3g_bdref.fddcell,
  t_voisines3g3g_bdref.umtsfddneighbouringcell;