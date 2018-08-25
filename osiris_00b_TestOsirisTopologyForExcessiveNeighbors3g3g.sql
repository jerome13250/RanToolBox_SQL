SELECT 
  public.osiris_fluxctn3g3g.* 
FROM 
  public.osiris_fluxctn3g3g LEFT JOIN public.t_voisines3g3g
  ON
	osiris_fluxctn3g3g."LCID_S" = t_voisines3g3g.localcellid_s AND
	osiris_fluxctn3g3g."LCID_V" = t_voisines3g3g.localcellid_v
WHERE 
  osiris_fluxctn3g3g."VOIS" = '1'
  AND t_voisines3g3g.localcellid_s IS NULL
  
ORDER BY
  osiris_fluxctn3g3g."NOM_S" ASC, 
  osiris_fluxctn3g3g."NOM_V" ASC;
