--Creation de fonction IsNumeric:
CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;



SELECT 
  *,
  CASE WHEN isnumeric(noria_installed3gcable."PERTES_900") THEN noria_installed3gcable."PERTES_900"::float ELSE NULL END 
  --to_number(COALESCE(noria_installed3gcable."PERTES_2200",'0'),'9999.99')
FROM 
  public.noria_installed3gcable;
