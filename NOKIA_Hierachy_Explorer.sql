DROP TABLE IF EXISTS t_nokia_hierarchical_tree;
CREATE TABLE t_nokia_hierarchical_tree (
	object_name TEXT,
	"managedObject_distName" TEXT,
	"managedObject_distName_parent" TEXT
	);

DO
$do$
DECLARE
_tbl text;
BEGIN
FOR _tbl  IN 
    SELECT quote_ident(table_schema) || '.'
        || quote_ident(table_name)      -- escape identifier and schema-qualify!
    FROM   information_schema.tables
    WHERE  table_name LIKE 'nokia\_%'  -- Tables omc nokia
    AND    table_name != 'nokia_board_definition' --Table perso qui ne devrait pas avoir ce nom...
    AND    table_name != 'nokia_PLMN'			--Cas particulier ROOT de la hierarchie
    AND    table_schema NOT LIKE 'pg_%'     -- exclude system schemas"
LOOP
  --  RAISE NOTICE '%',
   EXECUTE

  'INSERT INTO t_nokia_hierarchical_tree 
  SELECT DISTINCT
  replace(replace(''' || _tbl ||''',''"'',''''), ''public.nokia_'', ''''),
  regexp_replace(regexp_replace("managedObject_distName", ''-[0-9\s\.]+?/'', ''/'', ''g''),''-[0-9\s\.]+'', '''',''g''),
  regexp_replace(regexp_replace("managedObject_distName_parent", ''-[0-9\s\.]+?/'', ''/'', ''g''),''-[0-9\s\.]+'', '''',''g'')
FROM '|| _tbl;

END LOOP;
END
$do$;



