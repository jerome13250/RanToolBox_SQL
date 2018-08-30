/*cette requete sert a verifier que le code GN contenu dans "sbtsDescription" est le même que celui des cellules dans NORIA*/
SELECT 
  t_topologie4g_nokia."managedObject_SBTS", 
  t_topologie4g_nokia.name, 
  t_topologie4g_nokia."sbtsDescription", 
  t_topologie4g_nokia."sbtsName", 
  t_topologie4g_nokia."managedObject_distName", 
  t_topologie4g_nokia."managedObject_LNCEL", 
  t_topologie4g_nokia."LNCEL_name", 
  t_topologie4g_nokia."earfcnDL", 
  t_topologie4g_nokia."eutraCelId", 
  t_topologie4g_nokia."administrativeState", 
  t_topologie4g_nokia."operationalState", 
  noria_enodebcell."IDRESEAUCELLULE", 
  noria_enodebcell."NOM" AS "NORIA_NOM", 
  noria_enodebcell."GN"  AS "NORIA_GN"
FROM 
  public.t_topologie4g_nokia LEFT JOIN public.noria_enodebcell
  ON 
    t_topologie4g_nokia."eutraCelId" = noria_enodebcell."IDRESEAUCELLULE"
WHERE
  t_topologie4g_nokia."sbtsDescription" != noria_enodebcell."GN" AND
  noria_enodebcell."NOM" NOT LIKE 'REP%' --evite les repeteurs
  --OR noria_enodebcell."GN" IS NULL
  OR t_topologie4g_nokia."sbtsDescription" IS NULL
  OR t_topologie4g_nokia."sbtsDescription" = '';
