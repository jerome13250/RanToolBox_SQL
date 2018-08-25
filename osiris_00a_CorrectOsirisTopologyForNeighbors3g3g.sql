
UPDATE public.osiris_fluxctn3g3g
SET "VOIS" = '1'
FROM   public.t_voisines3g3g
WHERE  osiris_fluxctn3g3g."LCID_S" = t_voisines3g3g.localcellid_s AND
	osiris_fluxctn3g3g."LCID_V" = t_voisines3g3g.localcellid_v AND
	osiris_fluxctn3g3g."VOIS" = '0';


