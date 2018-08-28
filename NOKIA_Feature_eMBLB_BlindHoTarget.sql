--Liste des BlindHOTargetCell qui doivent être activés :

SELECT 
  "managedObject_version", 
  "ADJI_managedObject_distName", 
  object_type, 
  "managedObject_WCEL", 
  name_s, 
  "TargetCellDN", 
  adji_name, 
  "LCIDV", 
  "BlindHOTargetCell"
FROM 
  public.t_voisines3g3g_nokia_inter
WHERE
  "BlindHOTargetCell" = '0' AND 
  left(name_s,-1) = left(adji_name,-1) AND 
  "UARFCN_s" != '10787' AND
  "AdjiUARFCN" = '10787'

UNION

SELECT 
  "managedObject_version", 
  "ADJI_managedObject_distName", 
  object_type, 
  "managedObject_WCEL", 
  name_s, 
  "TargetCellDN", 
  adji_name, 
  "LCIDV", 
  "BlindHOTargetCell"
FROM 
  public.t_voisines3g3g_nokia_inter
WHERE
  "BlindHOTargetCell" = '1'  AND
  (
	left(name_s,-1) != left(adji_name,-1) OR 
	"UARFCN_s" = '10787' OR
	"AdjiUARFCN" != '10787'
  )
ORDER BY
  name_s,
  adji_name;
