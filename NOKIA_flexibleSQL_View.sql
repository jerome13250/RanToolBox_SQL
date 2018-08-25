--Crée une requete flexible en fonction de la table a analyser 
SELECT 

'SELECT 
name,
"managedObject_HOPS",
string_agg(replace("managedObject_distName_parent",''PLMN-PLMN/RNC-'',''''),''-'') AS rnc_list,
COUNT(name) AS count,' ||
string_agg(CHR(10) || '"' || column_name || '"' ,',') ||
'FROM 
public."nokia_HOPS"
GROUP BY
name,
"managedObject_HOPS",' ||
string_agg(CHR(10) || '"' || column_name || '"' ,',') ||
'ORDER BY 
"managedObject_HOPS"::int,
COUNT(name) DESC;' AS "--FlexiSql"

FROM information_schema.columns
WHERE
	table_name = 'nokia_HOPS' AND
	column_name != 'name' AND
	column_name NOT LIKE 'managedObject%' AND
	column_name NOT LIKE '%ChangeOrigin'
;



