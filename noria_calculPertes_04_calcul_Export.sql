SELECT 
  noria_celluleumts_reel."NOM", 
  noria_celluleumts_reel."ID_CELL_SI", 
  noria_celluleumts_reel."ID_NORIA_CELL", 
  noria_celluleumts_reel."GN", 
  noria_celluleumts_reel."BANDE", 
  noria_celluleumts_reel."CARRIER", 
  t_noria_pertes2200_calcul_resultats.info_pertes, 
  t_noria_pertes2200_calcul_resultats.pertes_totales
FROM 
  public.noria_celluleumts_reel, 
  public.t_noria_pertes2200_calcul_resultats
WHERE 
  noria_celluleumts_reel."ID_CELL_SI" = t_noria_pertes2200_calcul_resultats."ID_CELL_SI" AND
  noria_celluleumts_reel."ID_NORIA_CELL" = t_noria_pertes2200_calcul_resultats."ID_NORIA_CELL"
ORDER BY
    noria_celluleumts_reel."NOM";
