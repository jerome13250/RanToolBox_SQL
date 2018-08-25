SELECT 
  t_voisines_4g3g_alu.ltecell, 
  t_voisines_4g3g_alu.utrafddneighboringcellrelation, 
  t_voisines_4g3g_alu.cid, 
  t_voisines_4g3g_alu.rncid, 
  t_voisines_4g3g_alu.plmnmobilecountrycode, 
  t_voisines_4g3g_alu.plmnmobilenetworkcode, 
  t_voisines_4g3g_alu.noremove, 
  t_voisines_4g3g_alu.nohoorredirection,
  CASE	WHEN 
		t_voisines_4g3g_alu.rncid = '4' OR --Rajouter les rncid des RS construits par BYT et SFR
		t_voisines_4g3g_alu.plmnmobilecountrycode != '208' OR
		t_voisines_4g3g_alu.plmnmobilenetworkcode != '01'
		THEN 'blacklisting'::text 
	ELSE 'delete neighbour'::text 
	END 
	AS decision
FROM 
  public.t_voisines_4g3g_alu LEFT JOIN public.t_topologie3g
 ON
  t_voisines_4g3g_alu.rncid = t_topologie3g.rncid AND
  t_voisines_4g3g_alu.cid = t_topologie3g.cellid
 WHERE
  t_topologie3g.rncid is null and noremove = 'false'
order by 
  t_voisines_4g3g_alu.rncid::int,
  cid::int;
