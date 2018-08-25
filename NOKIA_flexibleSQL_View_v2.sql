--Crée une requete flexible en fonction de la table a analyser 
SELECT 

'SELECT 
--name,
"managedObject_IUR",
string_agg(replace("managedObject_distName_parent",''PLMN-PLMN/RNC-'','''') + "managedObject_IUR",''-'') AS list,
COUNT("managedObject_IUR") AS count,' ||
string_agg(CHR(10) || '"' || column_name || '"' ,',') ||
'FROM 
public."nokia_IUR"
GROUP BY
name,
"managedObject_IUR",' ||
string_agg(CHR(10) || '"' || column_name || '"' ,',') || CHR(10) ||
'ORDER BY 
"managedObject_HOPS"::int,
COUNT(name) DESC;' AS "--FlexiSql"

FROM information_schema.columns
WHERE
	table_name = 'nokia_IUR' AND
	--column_name != 'name' AND
	column_name NOT LIKE 'managedObject%' AND
	column_name NOT LIKE '%ChangeOrigin'
;



