SELECT 
  bdref_t_enodeb_ref.str_enodeb, 
  bdref_t_enodeb_ref.n_etat, 
  bdref_t_enodeb_ref.n_enodeb, 
  bdref_t_enodeb_ref.code_nidt, 
  bdref_t_enodeb_ref.idx_dr, 
  bdref_t_enodeb_ref.idx_palier_constructeur, 
  bdref_t_enodeb_ref.idx_region, 
  bdref_t_param_enodeb_noeud_cible.str_valeur, 
  bdref_t_noeud_enodeb.str_noeud, 
  bdref_t_param_enodeb_noeud_def.nom_champ,
  bdref_t_noeud_enodeb.idx_noeud_type,
  bdref_t_noeud_enodeb.str_noeud_label
  
FROM 
  public.bdref_t_enodeb_ref, 
  public.bdref_t_noeud_enodeb, 
  public.bdref_t_param_enodeb_noeud_cible, 
  public.bdref_t_param_enodeb_noeud_def
WHERE 
  bdref_t_enodeb_ref.idx_enodeb = bdref_t_param_enodeb_noeud_cible.idx_enodeb AND
  bdref_t_noeud_enodeb.idx_noeud_type = bdref_t_param_enodeb_noeud_def.idx_noeud_type AND
  bdref_t_noeud_enodeb.idx_noeud = bdref_t_param_enodeb_noeud_cible.idx_noeud AND
  bdref_t_param_enodeb_noeud_cible.idx_param_enodeb_noeud = bdref_t_param_enodeb_noeud_def.idx_param_enodeb_noeud AND
  bdref_t_noeud_enodeb.idx_noeud_type IN ('40000341','40000343');
