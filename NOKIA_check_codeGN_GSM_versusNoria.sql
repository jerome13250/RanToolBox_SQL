SELECT 
  t_topologie2g_nokia."BCF_name", 
  --t_topologie2g_nokia."BCF_managedObject_distName", 
  t_topologie2g_nokia."BCF_siteTemplateDescription", 
  --t_topologie2g_nokia."BTS_managedObject_distName", 
  --t_topologie2g_nokia."managedObject_BTS", 
  t_topologie2g_nokia."BTS_name", 
  t_topologie2g_nokia."locationAreaIdLAC", 
  t_topologie2g_nokia."cellId", 
  t_topologie2g_nokia."BTS_adminState", 
  noria_cellulesgsm."NOM", 
  noria_cellulesgsm."GN"
FROM 
  public.t_topologie2g_nokia INNER JOIN public.noria_cellulesgsm
  ON
    t_topologie2g_nokia."cellId" = noria_cellulesgsm."IDRESEAUCELLULE" AND
    t_topologie2g_nokia."locationAreaIdLAC" = noria_cellulesgsm."TAC/LAC"
WHERE
  (t_topologie2g_nokia."BCF_siteTemplateDescription" != noria_cellulesgsm."GN" 
  OR t_topologie2g_nokia."BCF_siteTemplateDescription" IS NULL
  OR t_topologie2g_nokia."BCF_siteTemplateDescription" = '')
  AND
  noria_cellulesgsm."NOM" NOT LIKE '%REP%'

ORDER BY
  t_topologie2g_nokia."BTS_name" ASC;
