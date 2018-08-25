SELECT
  t_voisines3g2g_nokia.*, 
  noria_cellulesgsm."NOM", 
  noria_cellulesgsm."ID_CELL_SI", 
  right(noria_cellulesgsm."GN",2)
FROM 
  public.t_voisines3g2g_nokia INNER JOIN public.noria_cellulesgsm
  ON
  t_voisines3g2g_nokia."AdjgCI" = noria_cellulesgsm."IDRESEAUCELLULE" AND
  t_voisines3g2g_nokia."AdjgLAC" = noria_cellulesgsm."TAC/LAC"
WHERE
  right(noria_cellulesgsm."GN",2) IN ('F4','R1','A1','F5','M2','C1','Q1', 'L2', 'M1', 'Z1', 'T3', 'Q2', 'F3', 'L1', 'S1')
ORDER BY
  "LCIDs";
