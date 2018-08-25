SELECT DISTINCT 
  t_voisines3g2g.rnc, 
  t_voisines3g2g.fddcell, 
  npo_clashcnlinterrat."VS_AggrCellListAmbigCellInterRAT(U1056)(Event)", 
  t_voisines3g2g.gsmneighbouringcell AS gsmneighbouringcell1, 
  t_voisines3g2g.userspecificinfo AS cellname2g1, 
  t_voisines3g2g.ncc, 
  t_voisines3g2g.bcc, 
  t_voisines3g2g.bcchfrequency AS bcch, 
  t_voisines3g2g.mobilecountrycode AS mcc1, 
  t_voisines3g2g.mobilenetworkcode AS mnc1, 
  t_voisines3g2g.civ AS ci1, 
  t_voisines3g2g.lacv AS lac1, 
  t_voisines3g2g_rank2.gsmneighbouringcell, 
  t_voisines3g2g_rank2.userspecificinfo AS cellname2g2,
  t_voisines3g2g_rank2.mobilecountrycode AS mcc2, 
  t_voisines3g2g_rank2.mobilenetworkcode AS mnc2, 
  t_voisines3g2g_rank2.civ AS ci2, 
  t_voisines3g2g_rank2.lacv AS lac2
FROM 
  public.t_voisines3g2g INNER JOIN public.t_voisines3g2g_rank2
		ON  t_voisines3g2g.fddcell = t_voisines3g2g_rank2.fddcell AND
		t_voisines3g2g.bcchfrequency = t_voisines3g2g_rank2.bcchfrequency AND
		t_voisines3g2g.ncc = t_voisines3g2g_rank2.ncc AND
		t_voisines3g2g.bcc = t_voisines3g2g_rank2.bcc
	
	INNER JOIN public.npo_clashcnlinterrat
		ON npo_clashcnlinterrat."CellName" = t_voisines3g2g.fddcell
WHERE 
	t_voisines3g2g.civ != t_voisines3g2g_rank2.civ 
	OR t_voisines3g2g.lacv != t_voisines3g2g_rank2.lacv  
ORDER BY
  t_voisines3g2g.fddcell ASC, 
  t_voisines3g2g.userspecificinfo ASC;
