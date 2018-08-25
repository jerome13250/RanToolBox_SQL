DROP TABLE IF EXISTS t_voisines3g3g_bdref;

CREATE TABLE t_voisines3g3g_bdref AS

SELECT 
  t_voisines3g3g.*, 
  bdreftopo1."Classe" AS classe_s, 
  bdreftopo2."Classe" AS classe_v
FROM 
  public.t_voisines3g3g LEFT JOIN public.bdref_t_topologie bdreftopo1
  ON
	t_voisines3g3g.localcellid_s = bdreftopo1."LCID"
  LEFT JOIN public.bdref_t_topologie bdreftopo2
  ON
	t_voisines3g3g.localcellid_v = bdreftopo2."LCID";
