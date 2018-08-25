--recherche des LCG qui n'ont pas de tokens HSUPA disponible :
SELECT 
  * 
FROM 
  public.t_topologie3g_nokia_tokens_schedulers
WHERE 
  t_topologie3g_nokia_tokens_schedulers."Per_LCG_HSUPA_LicenceKey" = 0 AND 
  t_topologie3g_nokia_tokens_schedulers.cell_count != 0;
