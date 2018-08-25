--Crée depuis BDREF la liste de tous les paramètres croisés toutes technos :
DROP TABLE IF EXISTS t_paramvois_check_00;
CREATE TABLE t_paramvois_check_00 AS
SELECT 
  bdref_t_param_vois_val.idx_param_vois, 
  bdref_t_param_vois_def.nom_champ_vois, 
  bdref_t_param_vois_def.str_reg, 
  bdref_t_param_vois_def.lst_idx, 
  bdref_t_param_vois_def.str_file, 
  bdref_t_param_vois_val.idx_classe_s, 
  tclasse1.str_classe AS str_classe_s, 
  bdref_t_param_vois_val.idx_classe_v, 
  tclasse2.str_classe AS str_classe_v, 
  bdref_t_param_vois_val.idx_palier, 
  bdref_t_param_vois_val.str_valeur,
  ''::text AS name
FROM 
  public.bdref_t_param_vois_val LEFT JOIN public.bdref_t_param_vois_def
  ON
	bdref_t_param_vois_val.idx_param_vois = bdref_t_param_vois_def.idx_param_vois
  LEFT JOIN public.bdref_t_classe tclasse1
  ON
	bdref_t_param_vois_val.idx_classe_s = tclasse1.idx_classe
  LEFT JOIN public.bdref_t_classe tclasse2
  ON
	bdref_t_param_vois_val.idx_classe_v = tclasse2.idx_classe;

--Cree la liste des objets HOPI et HOPS, on prend le rnc ran sharing comme référence car il contient tous les objets
--Cela est utile pour faire ensuite une jointure sur une table sans doublon d'objet
DROP TABLE IF EXISTS tmp_hop_list;
CREATE TABLE tmp_hop_list AS
SELECT 
  'ADJS'::text AS "object_type",
  "managedObject_HOPS" AS object_index, 
  name
FROM 
  public."nokia_HOPS"
WHERE
  "managedObject_distName_parent" = 'PLMN-PLMN/RNC-970'

UNION

SELECT 
  'ADJI'::text AS "object_type",
  "managedObject_HOPI", 
  name
FROM 
  public."nokia_HOPI"
WHERE
  "managedObject_distName_parent" = 'PLMN-PLMN/RNC-970'

ORDER BY 
  "object_type",
  object_index
  
;

--Mise a jour des noms HOP:
UPDATE t_paramvois_check_00
SET
  name = tmp_hop_list.name
FROM 
  public.tmp_hop_list
WHERE 
  t_paramvois_check_00.str_file = tmp_hop_list.object_type AND
  t_paramvois_check_00.str_valeur = tmp_hop_list.object_index AND --permet de discriminer ADJS et ADJI
  nom_champ_vois ILIKE '%HOP%'; -- filtre sur les paramètres hop;


--Mise a jour des noms SIB:
UPDATE t_paramvois_check_00
SET
  name = 
   --For CELL DCH meas only (0), For SIB and CELL DCH meas (1), For SIBbis and CELL DCH meas (2), For SIB only (3), For SIBbis only (4)
  CASE str_valeur
	WHEN '0' THEN 'dchOnly'
	WHEN '1' THEN 'sib11AndDch'
	WHEN '2' THEN 'sib11bisAndDch'
	WHEN '3' THEN 'sib11Only'
	WHEN '4' THEN 'sib11bisOnly'
	ELSE NULL END 
 
WHERE 
  t_paramvois_check_00.nom_champ_vois ILIKE 'Adj%SIB%';