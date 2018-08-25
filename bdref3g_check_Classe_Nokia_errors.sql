SELECT 
  * 
FROM 
  public.t_bdref3g_check_nokia_classe
WHERE 
  t_bdref3g_check_nokia_classe.classe_actuelle != t_bdref3g_check_nokia_classe.classe AND
  t_bdref3g_check_nokia_classe.classe_actuelle NOT LIKE '%hotSpot' AND
  (
	t_bdref3g_check_nokia_classe.classe_actuelle NOT LIKE 'Nokia_FDD900%' AND
	t_bdref3g_check_nokia_classe.classe  NOT LIKE 'Nokia_FDD900%')
;
