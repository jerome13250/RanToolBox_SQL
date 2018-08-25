DROP TABLE IF EXISTS t_voisines3g3g_rank2;

CREATE TABLE t_voisines3g3g_rank2 AS
SELECT DISTINCT
  vois1.rnc, 
  vois1.fddcell,
  opteo_clashcnlintrafreq."CNL Intra Freq" AS clashintrafreq, 
  vois1.dlfrequencynumber_s, 
  vois1.localcellid_s, 
  vois1.primaryscramblingcode_s, 
  vois1.locationareacode_s, 
  vois2.umtsfddneighbouringcell AS umtsfddneighbouringcell_rank2, 
  vois2.dlfrequencynumber_v AS dlfrequencynumber_v_rank2, 
  vois2.localcellid_v AS localcellid_v_rank2, 
  vois2.primaryscramblingcode_v AS primaryscramblingcode_v_rank2, 
  vois2.locationareacode_v AS locationareacode_v_rank2
FROM 
  public.t_voisines3g3g AS vois1 INNER JOIN public.t_voisines3g3g AS vois2
   ON  
	vois1.umtsfddneighbouringcell = vois2.fddcell
  INNER JOIN opteo_clashcnlintrafreq 
   ON
	vois1.fddcell = opteo_clashcnlintrafreq."Libellé"

 ;

