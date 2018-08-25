DROP TABLE IF EXISTS tmp_topo3g_mar;

CREATE TABLE tmp_topo3g_mar AS

SELECT  
  t_topo3g_cosector.fddcell_fdd10 AS fddcell,
  t_topo3g_cosector.lcid_fdd10 AS lcid,
  CASE WHEN t_topo3g_cosector.ci_fdd11 IS NULL THEN '' ELSE (t_topo3g_cosector.ci_fdd11) END || 
       CASE WHEN t_topo3g_cosector.ci_fdd12 IS NULL THEN '' ELSE ('-' || t_topo3g_cosector.ci_fdd12) END ||
       CASE WHEN t_topo3g_cosector.ci_fdd7 IS NULL THEN '' ELSE ('-' || t_topo3g_cosector.ci_fdd7) END
       AS twincell_list,
  t_topo3g_cosector.ci_fdd12 AS mar_list --FDD10->12
FROM 
  public.t_topo3g_cosector


UNION

SELECT  
  t_topo3g_cosector.fddcell_fdd11,
  t_topo3g_cosector.lcid_fdd11,
  t_topo3g_cosector.ci_fdd10 || --on est sur fdd11 donc fdd10 existe
       CASE WHEN t_topo3g_cosector.ci_fdd12 IS NULL THEN '' ELSE ('-' || t_topo3g_cosector.ci_fdd12) END ||
       CASE WHEN t_topo3g_cosector.ci_fdd7 IS NULL THEN '' ELSE ('-' || t_topo3g_cosector.ci_fdd7) END 
       AS twincell_list, 
  t_topo3g_cosector.ci_fdd10 || CASE WHEN t_topo3g_cosector.ci_fdd12 IS NULL THEN '' ELSE ('-' || t_topo3g_cosector.ci_fdd12) END 
	AS mar_list --FDD11->10 et 12
FROM 
  public.t_topo3g_cosector
WHERE
  t_topo3g_cosector.lcid_fdd11 <> ''

UNION

SELECT  
  t_topo3g_cosector.fddcell_fdd12,
  t_topo3g_cosector.lcid_fdd12,
  t_topo3g_cosector.ci_fdd10 || --on est sur fdd12 donc fdd10 existe
       '-' || t_topo3g_cosector.ci_fdd11 || --on est sur fdd12 donc fdd11 existe
       CASE WHEN t_topo3g_cosector.ci_fdd7 IS NULL THEN '' ELSE ('-' || t_topo3g_cosector.ci_fdd7) END 
       AS twincell_list,  
  t_topo3g_cosector.ci_fdd10-- || CASE WHEN t_topo3g_cosector.ci_fdd12 IS NULL THEN '' ELSE ('-' || t_topo3g_cosector.ci_fdd12) END 
	AS mar_list --FDD12->10
FROM 
  public.t_topo3g_cosector
WHERE
  t_topo3g_cosector.lcid_fdd12 <> ''

UNION

SELECT  
  t_topo3g_cosector.fddcell_fdd7,
  t_topo3g_cosector.lcid_fdd7,
  t_topo3g_cosector.ci_fdd10 || --on est sur fdd7 donc fdd10 existe
       '-' || t_topo3g_cosector.ci_fdd11 || --on est sur fdd7 donc fdd11 existe
       '-' || t_topo3g_cosector.ci_fdd12 --on est sur fdd7 donc fdd12 existe
       AS twincell_list,  
  t_topo3g_cosector.ci_fdd10 || '-' || t_topo3g_cosector.ci_fdd12 
	AS mar_list --FDD7->10 et 12
FROM 
  public.t_topo3g_cosector
WHERE
  t_topo3g_cosector.lcid_fdd7 <> '';