INSERT INTO public.noria_enodebcell
	(SELECT 
	noria_enodebcell_previ.* 
	FROM 
	public.noria_enodebcell_previ LEFT JOIN public.noria_enodebcell
		ON 
		noria_enodebcell_previ."IDRESEAUCELLULE" = noria_enodebcell."IDRESEAUCELLULE"
	WHERE
	noria_enodebcell."IDRESEAUCELLULE" IS NULL );


INSERT INTO public.noria_enodebcell
	(SELECT 
	noria_enodebcell_dep.* 
	FROM 
	public.noria_enodebcell_dep LEFT JOIN public.noria_enodebcell
		ON 
		noria_enodebcell_dep."IDRESEAUCELLULE" = noria_enodebcell."IDRESEAUCELLULE"
	WHERE
	noria_enodebcell."IDRESEAUCELLULE" IS NULL );