SELECT 
  t_voisines3g3g_bdref.*,
  bdref_paramclasse_nortelnortel."Valeur",
  CASE 	WHEN (t_voisines3g3g_bdref.locationareacode_s != t_voisines3g3g_bdref.locationareacode_v) THEN 'inter LAC'
	WHEN (t_voisines3g3g_bdref.routingareacode_s != t_voisines3g3g_bdref.routingareacode_v) THEN 'inter RAC'
        ELSE NULL END 
	AS inter_LAC_RAC,
  bdref_mapping_neighbrel_interlac.neighbrel_interlac
FROM 
  public.t_voisines3g3g_bdref LEFT JOIN public.bdref_paramclasse_nortelnortel
    ON 
	t_voisines3g3g_bdref.classe_s = bdref_paramclasse_nortelnortel."CLASSEs" AND
	t_voisines3g3g_bdref.classe_v = bdref_paramclasse_nortelnortel."CLASSEv"
  LEFT JOIN public.bdref_mapping_neighbrel_interlac
    ON
	bdref_paramclasse_nortelnortel."Valeur" = bdref_mapping_neighbrel_interlac.neighbrel_intralac
  
WHERE 
  t_voisines3g3g_bdref.classe_s = bdref_paramclasse_nortelnortel."CLASSEs" AND
  t_voisines3g3g_bdref.classe_v = bdref_paramclasse_nortelnortel."CLASSEv" AND
  (t_voisines3g3g_bdref.umtsneighrelationid LIKE 'STD_%' OR
   t_voisines3g3g_bdref.umtsneighrelationid LIKE '%XP%')
  AND 
  t_voisines3g3g_bdref.umtsneighrelationid NOT LIKE '%RanSharing%';
