-- FAIRE UN UPDATE TABLE pour les cellules existantes!!!
-- Faire un ADD pour les cellules absentes !!

UPDATE t_histo_swap_param_alu AS t

SET 
  fddcell = snap3g_fddcell.fddcell, 
  localcellid = snap3g_fddcell.localcellid, 
  cellselectionprofileid = snap3g_fddcell.cellselectionprofileid, 
  cellselectionwithpriorityprofileid = snap3g_fddcell.cellselectionwithpriorityprofileid, 
  hoconfid = snap3g_fddcell.hoconfid, 
  alarmprioritytableconfclassid = snap3g_fddintelligentmulticarriertrafficallocation.alarmprioritytableconfclassid
FROM 
  public.snap3g_fddcell, 
  public.snap3g_fddintelligentmulticarriertrafficallocation
WHERE 
  snap3g_fddcell.rnc = snap3g_fddintelligentmulticarriertrafficallocation.rnc AND
  snap3g_fddcell.fddcell = snap3g_fddintelligentmulticarriertrafficallocation.fddcell AND
  t.localcellid = snap3g_fddcell.localcellid
;

INSERT INTO t_histo_swap_param_alu (fddcell,localcellid,cellselectionprofileid,cellselectionwithpriorityprofileid,hoconfid,alarmprioritytableconfclassid)
SELECT 
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.localcellid, 
  snap3g_fddcell.cellselectionprofileid, 
  snap3g_fddcell.cellselectionwithpriorityprofileid, 
  snap3g_fddcell.hoconfid, 
  snap3g_fddintelligentmulticarriertrafficallocation.alarmprioritytableconfclassid
FROM 
  public.snap3g_fddcell INNER JOIN snap3g_fddintelligentmulticarriertrafficallocation
  ON
    snap3g_fddcell.rnc = snap3g_fddintelligentmulticarriertrafficallocation.rnc AND
    snap3g_fddcell.fddcell = snap3g_fddintelligentmulticarriertrafficallocation.fddcell
  LEFT JOIN public.t_histo_swap_param_alu   
  ON
    t_histo_swap_param_alu.localcellid = snap3g_fddcell.localcellid
WHERE
  t_histo_swap_param_alu.localcellid is null;
