SELECT * 
FROM information_schema.columns 
WHERE TRUE
AND table_schema = 'public'
AND column_name ILIKE 'ISHO%'