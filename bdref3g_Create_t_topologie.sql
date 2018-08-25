DROP TABLE IF EXISTS bdref_t_topologie;

CREATE TABLE bdref_t_topologie AS

SELECT 
  bdref_tmp_topologie."OMC", 
  bdref_tmp_topologie."BSC", 
  bdref_tmp_topologie."LAC", 
  bdref_tmp_topologie."LCID" AS bdref_idcell, 
  bdref_tmp_idcell_3g.lcid AS "LCID", 
  bdref_tmp_idcell_3g.code_nidt AS "NIDT", 
  bdref_tmp_idcell_3g.n_noeud AS "NOEUD", 
  bdref_tmp_topologie."Classe"
FROM 
  public.bdref_tmp_topologie, 
  public.bdref_tmp_idcell_3g
WHERE 
  bdref_tmp_topologie."LCID" = bdref_tmp_idcell_3g.idcell;
