SELECT 
  noria_installed3gamplifaiblebruitsimple."ID_CELL_SI", 
  noria_installed3gamplifaiblebruitsimple."ID_NORIA_CELL", 
  noria_installed3gamplifaiblebruitsimple."ID_EQPT", 
  noria_installed3gamplifaiblebruitsimple."CAT_REF", 
  noria_installed3gamplifaiblebruitsimple."IDENTIFIANT_SI",
  'amplifaiblebruitsimple' AS object_type, 
  noria_catalog."NOM_CARAC", 
  noria_catalog."VALEUR|$|"
FROM 
  public.noria_installed3gamplifaiblebruitsimple LEFT JOIN public.noria_catalog
ON 
	noria_installed3gamplifaiblebruitsimple."CAT_REF" = noria_catalog."CAT_REF"
WHERE
  --noria_installed3gamplifaiblebruitduplexe."ID_CELL_SI" = '00000001A1/4'
 "NOM_CARAC" Like 'Perte duplexeur 2200 (dB)' 
 AND (
	noria_installed3gamplifaiblebruitsimple."ID_CELL_SI" LIKE '%J%' OR 
	noria_installed3gamplifaiblebruitsimple."ID_CELL_SI" LIKE '%H%' OR
	noria_installed3gamplifaiblebruitsimple."ID_CELL_SI" LIKE '%V%'
	)
;