--Creation de la fonction last
--Source = https://wiki.postgresql.org/wiki/First/last_(aggregate)

--CREATE OR REPLACE FUNCTION public.last_agg ( anyelement, anyelement )
--RETURNS anyelement LANGUAGE sql IMMUTABLE STRICT AS $$
--        SELECT $2;
--$$;

--CREATE AGGREGATE public.last (
----        sfunc    = public.last_agg,
--        basetype = anyelement,
--        stype    = anyelement
--);



--Recherche de la derniere colonne de la table en cours d'etude
--The result of a SQL command yielding a single row (possibly of multiple columns) can be assigned to a record variable,
-- row-type variable, or list of scalar variables. This is done by writing the base SQL command and adding an INTO clause.
--DECLARE
	--test varchar;
--BEGIN
	SELECT last(req.column_name) INTO var_celllist_name
	FROM (
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS 
		where TABLE_NAME='t_twincelllist_corrections'
	) AS req;
	--IF NOT FOUND THEN
	--	RAISE EXCEPTION 'column not found';
	--END IF;

	
--END

