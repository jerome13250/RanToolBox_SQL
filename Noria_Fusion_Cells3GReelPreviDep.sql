INSERT INTO public.noria_celluleumts_reel
	(SELECT 
	noria_celluleumts_previ.* 
	FROM 
	public.noria_celluleumts_previ LEFT JOIN public.noria_celluleumts_reel
		ON 
		noria_celluleumts_previ."IDRESEAUCELLULE" = noria_celluleumts_reel."IDRESEAUCELLULE"
	WHERE
	noria_celluleumts_reel."IDRESEAUCELLULE" IS NULL );

INSERT INTO public.noria_celluleumts_reel
	(SELECT 
	noria_celluleumts_dep.* 
	FROM 
	public.noria_celluleumts_dep LEFT JOIN public.noria_celluleumts_reel
		ON 
		noria_celluleumts_dep."IDRESEAUCELLULE" = noria_celluleumts_reel."IDRESEAUCELLULE"
	WHERE
	noria_celluleumts_reel."IDRESEAUCELLULE" IS NULL );