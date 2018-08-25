SELECT 
  bdref_incohparam_cell.*, 
  t_topologie3g.unknownstatus, 
  t_topologie3g.administrativestate, 
  t_topologie3g.operationalstate, 
  t_topologie3g.availabilitystatus
FROM 
  public.bdref_incohparam_cell, 
  public.t_topologie3g
WHERE 
  bdref_incohparam_cell."LCID" = t_topologie3g.localcellid
ORDER BY
  --bdref_incohparam_cell."Paramètre",
  bdref_incohparam_cell."NOM";
