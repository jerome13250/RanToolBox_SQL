CREATE OR REPLACE FUNCTION castnumeric(text) RETURNS NUMERIC AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN x;
EXCEPTION WHEN others THEN
    RETURN 'NaN'::numeric;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;

DROP TABLE IF EXISTS t_noria_pertes2200_listmateriel;
CREATE TABLE t_noria_pertes2200_listmateriel AS

--Objet Ampli duplexe:
SELECT 
  noria_installed3gamplifaiblebruitduplexe."ID_CELL_SI", 
  noria_installed3gamplifaiblebruitduplexe."ID_NORIA_CELL", 
  noria_installed3gamplifaiblebruitduplexe."ID_EQPT",
  'amplifaiblebruitduplexe' AS object_type, 
  noria_installed3gamplifaiblebruitduplexe."CAT_REF", 
  noria_catalog."NOM_CARAC", 
  noria_catalog."VALEUR|$|",
  castnumeric(replace("VALEUR|$|", '|$|', ''))+0.1 AS numeric_value
FROM 
  public.noria_installed3gamplifaiblebruitduplexe LEFT JOIN public.noria_catalog
ON 
	noria_installed3gamplifaiblebruitduplexe."CAT_REF" = noria_catalog."CAT_REF"
WHERE
  "NOM_CARAC" Like 'Perte duplexeur 2200 (dB)'

UNION

--Objet Bretelle:
SELECT 
  "ID_CELL_SI", 
  "ID_NORIA_CELL", 
  "ID_EQPT", 
  'installed3gbretelle' AS object_type, 
  "CAT_REF",
  "USAGE", 
  "PERTES_2200",
  castnumeric(replace("PERTES_2200", '|$|', ''))+0.1 AS numeric_value
FROM 
  public.noria_installed3gbretelle


UNION

--Objet cables:
SELECT 
  "ID_CELL_SI", 
  "ID_NORIA_CELL", 
  "ID_EQPT", 
  'installed3gcable' AS object_type, 
  "CAT_REF",
  "USAGE", 
  "PERTES_2200",
  castnumeric(replace("PERTES_2200", '|$|', ''))+0.1 AS numeric_value
FROM 
  public.noria_installed3gcable

UNION

--Objet Charge Passive:
-- Les charges passives indiquent un montage exotique , non pris en charge => pertes = NaN
SELECT DISTINCT
  noria_installed3gchargespassives."ID_CELL_SI", 
  noria_installed3gchargespassives."ID_NORIA_CELL", 
  noria_installed3gchargespassives."ID_EQPT",
  'installed3gchargespassives' AS object_type,
  noria_installed3gchargespassives."CAT_REF", 
  '' AS "USAGE", 
  'NaN' AS "PERTES_2200",
  'NaN'::numeric AS numeric_value
FROM 
  public.noria_installed3gchargespassives 


UNION

--Objet coupleurhybridetx:
-- Les coupleurhybridetx indiquent un montage exotique , non pris en charge => pertes = NaN
SELECT DISTINCT
  noria_installed3gcoupleurhybridetx."ID_CELL_SI", 
  noria_installed3gcoupleurhybridetx."ID_NORIA_CELL", 
  noria_installed3gcoupleurhybridetx."ID_EQPT",
  'installed3gcoupleurhybridetx' AS object_type,
  noria_installed3gcoupleurhybridetx."CAT_REF", 
  '' AS "USAGE", 
  'NaN' AS "PERTES_2200",
  'NaN'::numeric AS numeric_value
FROM 
  public.noria_installed3gcoupleurhybridetx 
--WHERE "ID_CELL_SI" = '00000020V1/7'

UNION

--Objet installed3gduplexeur:
-- Les installed3gduplexeur indiquent un montage exotique , non pris en charge => pertes = NaN
SELECT DISTINCT
  noria_installed3gduplexeur."ID_CELL_SI", 
  noria_installed3gduplexeur."ID_NORIA_CELL", 
  noria_installed3gduplexeur."ID_EQPT",
  'installed3gduplexeur' AS object_type,
  noria_installed3gduplexeur."CAT_REF", 
  '' AS "USAGE", 
  'NaN' AS "PERTES_2200",
  'NaN'::numeric AS numeric_value 
FROM 
  public.noria_installed3gduplexeur 

UNION

--Objet installed3grepartiteurdantennes:
-- Les installed3grepartiteurdantennes indiquent un montage exotique , non pris en charge => pertes = NaN
SELECT DISTINCT
  noria_installed3grepartiteurdantennes."ID_CELL_SI", 
  noria_installed3grepartiteurdantennes."ID_NORIA_CELL", 
  noria_installed3grepartiteurdantennes."ID_EQPT",
  'installed3grepartiteurdantennes' AS object_type,
  noria_installed3grepartiteurdantennes."CAT_REF", 
  '' AS "USAGE", 
  'NaN' AS "PERTES_2200",
  'NaN'::numeric AS numeric_value 
FROM 
  public.noria_installed3grepartiteurdantennes 

UNION

--DIPLEXEURS:
SELECT 
  noria_installed3gdiplexeur."ID_CELL_SI", 
  noria_installed3gdiplexeur."ID_NORIA_CELL", 
  noria_installed3gdiplexeur."ID_EQPT",
  'diplexeur' AS object_type, 
  noria_installed3gdiplexeur."CAT_REF", 
  noria_catalog."NOM_CARAC", 
  noria_catalog."VALEUR|$|",
  castnumeric(replace("VALEUR|$|", '|$|', ''))+0.1 AS numeric_value
FROM 
  public.noria_installed3gdiplexeur LEFT JOIN public.noria_catalog
  ON 
    noria_installed3gdiplexeur."CAT_REF" = noria_catalog."CAT_REF"
WHERE
  "NOM_CARAC" LIKE 'Perte insertion 2200 (dB)'

UNION

--TRIPLEXEURS:
SELECT 
  noria_installed3gtriplexeur."ID_CELL_SI", 
  noria_installed3gtriplexeur."ID_NORIA_CELL", 
  noria_installed3gtriplexeur."ID_EQPT",
  'triplexeur' AS object_type, 
  noria_installed3gtriplexeur."CAT_REF", 
  noria_catalog."NOM_CARAC", 
  noria_catalog."VALEUR|$|",
  castnumeric(replace("VALEUR|$|", '|$|', ''))+0.1 AS numeric_value
FROM 
  public.noria_installed3gtriplexeur LEFT JOIN public.noria_catalog
  ON 
    noria_installed3gtriplexeur."CAT_REF" = noria_catalog."CAT_REF"
WHERE
  "NOM_CARAC" LIKE 'Perte insertion 2200 (dB)'


UNION

--QUADRIPLEXEURS:
SELECT 
  noria_installed3gquadriplexeur."ID_CELL_SI", 
  noria_installed3gquadriplexeur."ID_NORIA_CELL", 
  noria_installed3gquadriplexeur."ID_EQPT",
  'quadriplexeur' AS object_type, 
  noria_installed3gquadriplexeur."CAT_REF", 
  noria_catalog."NOM_CARAC", 
  noria_catalog."VALEUR|$|",
  castnumeric(replace("VALEUR|$|", '|$|', ''))+0.1 AS numeric_value
FROM 
  public.noria_installed3gquadriplexeur LEFT JOIN public.noria_catalog
  ON 
    noria_installed3gquadriplexeur."CAT_REF" = noria_catalog."CAT_REF"
WHERE
  "NOM_CARAC" LIKE 'Perte insertion 2200 (dB)'


UNION

--PENTAPLEXEURS:
SELECT 
  noria_installed3gpentaplexeur."ID_CELL_SI", 
  noria_installed3gpentaplexeur."ID_NORIA_CELL", 
  noria_installed3gpentaplexeur."ID_EQPT",
  'pentaplexeur' AS object_type, 
  noria_installed3gpentaplexeur."CAT_REF", 
  noria_catalog."NOM_CARAC", 
  noria_catalog."VALEUR|$|",
  castnumeric(replace("VALEUR|$|", '|$|', ''))+0.1 AS numeric_value
FROM 
  public.noria_installed3gpentaplexeur LEFT JOIN public.noria_catalog
  ON 
    noria_installed3gpentaplexeur."CAT_REF" = noria_catalog."CAT_REF"
WHERE
  "NOM_CARAC" LIKE 'Perte insertion 2200 (dB)'

;
