SELECT 
  t_voisines3g3g_nokia_intra.* 
FROM 
  public.t_voisines3g3g_nokia_intra LEFT JOIN t_topologie3g_nokia --jointure avec la topo nokia
  ON
	t_voisines3g3g_nokia_intra."AdjsRNCid" = t_topologie3g_nokia."RNC_id" AND
	t_voisines3g3g_nokia_intra."AdjsCI" = t_topologie3g_nokia."CId"

  LEFT JOIN public.t_topologie3g --jointure avec la topo alu
  ON
	t_voisines3g3g_nokia_intra."AdjsRNCid" = t_topologie3g.rncid AND
	t_voisines3g3g_nokia_intra."AdjsCI" = t_topologie3g.cellid
WHERE
  (
	t_topologie3g_nokia."RNC_id" IS NULL OR --N'existe pas dans la topo nokia
	t_topologie3g_nokia."WBTSName" IS NULL -- Ou n'existe qu'en tant que cellule externe pour NOKIA
  ) AND
  t_topologie3g.nodeb IS NULL  -- Cellule n'existe pas chez ALU
  AND 
  "AdjsRNCid" NOT IN ('159','4','987','989','994','995')--Exclusion des RNCs Femto-159-Monaco-4, RanSharing-987-989-994-995
ORDER BY 
  adjs_name,
  name_s

  ;
