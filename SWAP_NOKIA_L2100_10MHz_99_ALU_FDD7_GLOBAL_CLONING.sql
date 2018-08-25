--creation du plan de voisines ALU fdd7-fdd7 cloné depuis fdd10-fdd10
DROP TABLE IF EXISTS t_voisnokia_fdd7alu_cloneplan;
CREATE TABLE t_voisnokia_fdd7alu_cloneplan AS
SELECT 
  mapping1.name_fdd7 AS name_s, 
  mapping1."LCID_fdd7" AS "LCIDS", 
  mapping1."UARFCN_fdd7" AS "UARFCN_s", 
  mapping2.name_fdd7 AS name_v, 
  mapping2."LCID_fdd7" AS "LCIDV", 
  mapping2."UARFCN_fdd7" AS "UARFCN_v", 
  t_voisnokia_intra_fdd10_ranked.ranking, 
  t_voisnokia_intra_fdd10_ranked.distance_km
FROM 
  public.t_voisnokia_intra_fdd10_ranked, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping1, 
  public.t_voisnokia_mapping_fdd10_fdd7 mapping2
WHERE 
  t_voisnokia_intra_fdd10_ranked."LCIDS" = mapping1."LCID_fdd10" AND
  t_voisnokia_intra_fdd10_ranked."LCIDV" = mapping2."LCID_fdd10" AND
  t_voisnokia_intra_fdd10_ranked.ranking <= 25;


--Voisinage total fdd7-fdd7 ALU:
SELECT 
  t_voisnokia_fdd7alu_cloneplan.name_s, 
  t_voisnokia_fdd7alu_cloneplan."LCIDS", 
  t_voisnokia_fdd7alu_cloneplan."UARFCN_s", 
  t_voisnokia_fdd7alu_cloneplan.name_v, 
  t_voisnokia_fdd7alu_cloneplan."LCIDV", 
  t_voisnokia_fdd7alu_cloneplan."UARFCN_v", 
  t_voisnokia_fdd7alu_cloneplan.ranking, 
  t_voisnokia_fdd7alu_cloneplan.distance_km,
  'A'::text AS "Opération"
FROM 
  public.t_voisnokia_fdd7alu_cloneplan LEFT JOIN public.t_voisines3g3g
  ON
	t_voisnokia_fdd7alu_cloneplan."LCIDS" = t_voisines3g3g.localcellid_s AND
	t_voisnokia_fdd7alu_cloneplan."LCIDV" = t_voisines3g3g.localcellid_v
WHERE
  t_voisines3g3g.localcellid_s IS NULL AND
  ranking <= 25

UNION

SELECT 
  t_voisines3g3g.fddcell, 
  t_voisines3g3g.localcellid_s, 
  t_voisines3g3g.dlfrequencynumber_s, 
  t_voisines3g3g.umtsfddneighbouringcell, 
  t_voisines3g3g.localcellid_v, 
  t_voisines3g3g.dlfrequencynumber_v,
  t_voisnokia_fdd7alu_cloneplan.ranking, 
  t_voisnokia_fdd7alu_cloneplan.distance_km,
  'S'::text AS "Opération"
FROM 
  public.t_voisines3g3g LEFT JOIN public.t_voisnokia_fdd7alu_cloneplan
  ON
    t_voisines3g3g.localcellid_s = t_voisnokia_fdd7alu_cloneplan."LCIDS" AND
    t_voisines3g3g.localcellid_v = t_voisnokia_fdd7alu_cloneplan."LCIDV"
WHERE
  t_voisnokia_fdd7alu_cloneplan."LCIDV" IS NULL AND
  t_voisines3g3g.dlfrequencynumber_s = '10712' AND
  t_voisines3g3g.dlfrequencynumber_v = '10712'

ORDER BY 
  name_s, 
  name_v
;
