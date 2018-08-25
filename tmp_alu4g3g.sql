--1er Correctif 530 lignes

SELECT 
  t_voisines_4g3g_alu.enbequipment,
  t_voisines_4g3g_alu.version,
  t_voisines_4g3g_alu.enb,
  t_voisines_4g3g_alu.ltecell,
  t_voisines_4g3g_alu.utraneighboring,
  t_voisines_4g3g_alu.utrafddneighboringfreqconf,
  t_voisines_4g3g_alu.utrafddneighboringcellrelation,
  tmp_unicitecellid_05_nouveauxcellid.cellid AS cid, --NOUVELLE VALEUR DE LCID
  t_voisines_4g3g_alu.iscellincludedforredirectionassistance,
  t_voisines_4g3g_alu.iscollocated,
  t_voisines_4g3g_alu.lac,
  t_voisines_4g3g_alu.measuredbyanr,
  t_voisines_4g3g_alu.nohoorredirection,
  t_voisines_4g3g_alu.noremove,
  t_voisines_4g3g_alu.physcellidutra,
  t_voisines_4g3g_alu.rac,
  t_voisines_4g3g_alu.rncaccessid,
  t_voisines_4g3g_alu.userlabel,
  t_voisines_4g3g_alu.voiceoveripcapability,
  t_voisines_4g3g_alu.plmnmobilecountrycode, --pour verification seulement
  t_voisines_4g3g_alu.plmnmobilenetworkcode, --pour verification seulement
  t_voisines_4g3g_alu.rncid --pour verification seulement
  
FROM 
  public.t_voisines_4g3g_alu,
  public.tmp_unicitecellid_05_nouveauxcellid
WHERE 
  t_voisines_4g3g_alu.rncid = tmp_unicitecellid_05_nouveauxcellid.rncid AND
  t_voisines_4g3g_alu.cid = tmp_unicitecellid_05_nouveauxcellid.cellid_old AND --A corriger ! enlever le _old
  tmp_unicitecellid_05_nouveauxcellid.rnc = 'MARSESTM6';