SELECT DISTINCT
  double1.rnc, 
  double1.rncid, 
  double1.fddcell, 
  double1.localcellid, 
  double1.cellid::int, 
  double1.info, 
  noria1."NOM" AS nom_noria, 
  noria1."GN",
  noria1."ETAT_DEPL" AS "noria1_ETAT_DEPL",
  noria1."ETAT_FONCT" AS "noria1_ETAT_FONCT",
  archi1."RNC NOKIA" AS "ARCHI_RNC_NOKIA",
  double2.rnc AS rnc_actuel, 
  double2.rncid, 
  double2.fddcell, 
  double2.localcellid, 
  double2.cellid, 
  double2.info, 
  noria2."NOM" AS nom_noria2, 
  noria2."GN",
  noria2."ETAT_DEPL" AS "noria2_ETAT_DEPL",
  noria2."ETAT_FONCT" AS "noria2_ETAT_FONCT",
  archi2."RNC NOKIA"
FROM 
  public.tmp_unicitecellid_01_listcellsdoubles AS double1 
  LEFT JOIN public.t_noria_topo_3g AS noria1
  ON
     double1.localcellid = noria1."IDRESEAUCELLULE"
  LEFT JOIN public.t_archi_nokia_cible AS archi1
  ON
     noria1."GN" = archi1."Code"
  INNER JOIN public.tmp_unicitecellid_01_listcellsdoubles double2
  ON 
      double1.cellid = double2.cellid
  LEFT JOIN public.t_noria_topo_3g AS noria2
  ON
	double2.localcellid = noria2."IDRESEAUCELLULE"
  LEFT JOIN public.t_archi_nokia_cible AS archi2
  ON
     noria2."GN" = archi2."Code"
WHERE 
   double1.localcellid != double2.localcellid AND
   ( archi1."RNC NOKIA" = archi2."RNC NOKIA" OR
   archi1."RNC NOKIA" IS NULL OR 
   archi2."RNC NOKIA" IS NULL )
ORDER BY
   --archi1."RNC NOKIA"
   double1.cellid::int,
   double1.fddcell;
