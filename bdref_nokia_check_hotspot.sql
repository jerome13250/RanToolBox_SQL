SELECT 
  bdref_t_topologie."OMC", 
  bdref_t_topologie."BSC", 
  bdref_t_topologie."LAC", 
  bdref_t_topologie.bdref_idcell, 
  bdref_t_topologie."LCID", 
  bdref_t_topologie."NIDT", 
  bdref_t_topologie."NOEUD", 
  bdref_t_topologie."Classe", 
  bdref_nokia_template_cellules."CellProfile ", 
  bdref_nokia_template_cellules."NOM"
FROM 
  public.bdref_t_topologie INNER JOIN 
  public.bdref_nokia_template_cellules
  ON 
	bdref_t_topologie."LCID" = bdref_nokia_template_cellules."LCID"
WHERE
  bdref_nokia_template_cellules."CellProfile " ILIKE '%Hotspot';
