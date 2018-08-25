SELECT 
  t_voisines3g3g_bdref.rnc, 
  t_voisines3g3g_bdref.rncid_s, 
  t_voisines3g3g_bdref.nodeb_s, 
  t_voisines3g3g_bdref.fddcell, 
  t_voisines3g3g_bdref.dlfrequencynumber_s, 
  t_voisines3g3g_bdref.localcellid_s AS "LCIDS", 
  t_voisines3g3g_bdref.classe_s AS classe_s, 
  t_voisines3g3g_bdref.umtsfddneighbouringcell, 
  t_voisines3g3g_bdref.dlfrequencynumber_v, 
  t_voisines3g3g_bdref.localcellid_v AS "LCIDV", 
  t_voisines3g3g_bdref.classe_v AS classe_v, 
  t_voisines3g3g_bdref.umtsneighrelationid AS omc_umtsneighrelationid,
  'umtsNeighRelationId' AS parametre,
  'RA hotspot' AS commentaire,
	--FDD10 en premier:
  CASE 	WHEN ( --cas 1 : fdd10 bifreq vers fdd11
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+1_%FDD10%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2\_%FDD10%') --bifreq fdd10
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD11%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_08_FDD10_FDD11'
	WHEN ( --cas 2 : fdd10 tri ou quadrifreq vers fdd11
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+2_%FDD10%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2+%FDD10%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR3%FDD10%') --tri ou quadrifreq fdd10
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD11%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_24_TriFrequence_FDD10_FDD11'
	WHEN ( --cas 3 : fdd10 tri ou quadrifreq vers fdd12
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+2_%FDD10%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2+%FDD10%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR3%FDD10%') --tri ou quadrifreq fdd10
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD12%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_25_TriFrequence_FDD10_FDD12'

	
	--FDD11 :
	WHEN ( --cas 6 : fdd11 bifreq vers fdd10
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+1_%FDD11%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2\_%FDD11%') --bifreq fdd11
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD10%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_07_FDD11_FDD10'
	WHEN ( --cas 5 : fdd11 tri ou quadrifreq vers fdd10
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+2_%FDD11%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2+%FDD11%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR3%FDD11%') --tri ou quadrifreq fdd11
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD10%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_26_TriFrequence_FDD11_FDD10'
	WHEN ( --cas 4 : fdd11 tri ou quadrifreq vers fdd12
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+2_%FDD11%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2+%FDD11%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR3%FDD11%') --tri ou quadrifreq fdd11
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD12%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_27_TriFrequence_FDD11_FDD12'


	--FDD12 :
	WHEN ( --cas 8 : fdd12 tri ou quadrifreq vers fdd10
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+2_%FDD12%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2+%FDD12%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR3%FDD12%') --tri ou quadrifreq fdd12
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD10%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_28_TriFrequence_FDD12_FDD10'
	WHEN ( --cas 7 : fdd12 tri ou quadrifreq vers fdd11
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+2_%FDD12%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2+%FDD12%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR3%FDD12%') --tri ou quadrifreq fdd12
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD11%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_29_TriFrequence_FDD12_FDD11'

	--FDD7 :
	WHEN ( --cas 9 : fdd7 tri ou quadrifreq vers fdd12
		(t_voisines3g3g_bdref.classe_s LIKE 'STSR1+2_%FDD7%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR2+%FDD7%' OR t_voisines3g3g_bdref.classe_s LIKE 'STSR3%FDD7%') --tri ou quadrifreq fdd7
		AND t_voisines3g3g_bdref.classe_v LIKE '%FDD12%'
	     )
	     THEN 'UmtsNeighbouring/0 UmtsNeighbouringRelation/STD_66_QuaFrequence_FDD7_FDD12'

	     
	ELSE NULL END 
	AS valeur
  
FROM 
  public.t_voisines3g3g_bdref
WHERE 
  t_voisines3g3g_bdref.nodeb_s = t_voisines3g3g_bdref.nodeb_v AND 
  --t_voisines3g3g_bdref.classe_s NOT LIKE '%HotSpot' AND
  t_voisines3g3g_bdref.umtsneighrelationid LIKE '%HotSpot' AND
  t_voisines3g3g_bdref.dlfrequencynumber_s != t_voisines3g3g_bdref.dlfrequencynumber_v AND
  t_voisines3g3g_bdref.dlfrequencynumber_v != '3011'
  --AND fddcell = 'BASTIA_CV_U11' --pour test
ORDER BY
  t_voisines3g3g_bdref.fddcell ASC, 
  t_voisines3g3g_bdref.umtsfddneighbouringcell ASC;
