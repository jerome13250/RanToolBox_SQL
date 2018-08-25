DROP TABLE IF EXISTS tmp_unicitecellid_05_nouveauxcellid;
CREATE TABLE tmp_unicitecellid_05_nouveauxcellid AS

SELECT 
  tmp_unicitecellid_02_listcellstomodify.rnc, 
  tmp_unicitecellid_02_listcellstomodify.rncid, 
  tmp_unicitecellid_02_listcellstomodify.fddcell, 
  tmp_unicitecellid_02_listcellstomodify.localcellid, 
  tmp_unicitecellid_02_listcellstomodify.cellid AS cellid_old, 
  tmp_unicitecellid_02_listcellstomodify.info, 
  tmp_unicitecellid_02_listcellstomodify.ranking, 
  tmp_unicitecellid_02_listcellstomodify.rownumber, 
  tmp_unicitecellid_04_listcellid65535_ranked.liste_cellid AS cellid
FROM 
  public.tmp_unicitecellid_02_listcellstomodify, 
  public.tmp_unicitecellid_04_listcellid65535_ranked
WHERE 
  tmp_unicitecellid_02_listcellstomodify.rownumber = tmp_unicitecellid_04_listcellid65535_ranked.rownumber;
