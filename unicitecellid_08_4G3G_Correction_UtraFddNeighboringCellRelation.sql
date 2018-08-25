-- Mise en forme RncAccess dans utrafddneighboringcellrelation
UPDATE snap4g_utrafddneighboringcellrelation AS t
 SET 
  rncaccessid = replace(t.rncaccessid,'UtranAccessGroup/0 RncAccess/','')
;

--Creation de la table de reference 4g3g :
DROP TABLE IF EXISTS t_voisines_4g3g_alu;
CREATE TABLE t_voisines_4g3g_alu AS

SELECT 
  snap4g_utrafddneighboringcellrelation.*,
  snap4g_enbequipment.systemrelease AS version,
  snap4g_rncaccess.plmnmobilecountrycode, 
  snap4g_rncaccess.plmnmobilenetworkcode, 
  snap4g_rncaccess.rncid
FROM 
  public.snap4g_utrafddneighboringcellrelation INNER JOIN public.snap4g_rncaccess
  ON
	snap4g_utrafddneighboringcellrelation.enbequipment = snap4g_rncaccess.enbequipment AND
	snap4g_utrafddneighboringcellrelation.rncaccessid = snap4g_rncaccess.rncaccess
  INNER JOIN public.snap4g_enbequipment
  ON
	snap4g_utrafddneighboringcellrelation.enbequipment = snap4g_enbequipment.enbequipment
  
;

--Creation de la table des vois 4g3g a modifier :
DROP TABLE IF EXISTS t_alu4g_UtraFddNeighboringCellRelation_generic_creation;
CREATE TABLE t_alu4g_UtraFddNeighboringCellRelation_generic_creation AS

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
  t_voisines_4g3g_alu.cid = tmp_unicitecellid_05_nouveauxcellid.cellid_old;






