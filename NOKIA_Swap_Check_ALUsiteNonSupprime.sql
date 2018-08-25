SELECT 
  "nokia_WCEL".name, 
  "nokia_WCEL"."managedObject_WCEL", 
  "nokia_WCEL"."AdminCellState", 
  snap3g_fddcell.fddcell, 
  snap3g_fddcell.localcellid, 
  snap3g_fddcell.administrativestate
FROM 
  public."nokia_WCEL" INNER JOIN public.snap3g_fddcell
  ON
    "nokia_WCEL"."managedObject_WCEL" = snap3g_fddcell.localcellid
WHERE
  "nokia_WCEL"."AdminCellState" != '0'
ORDER BY
  "nokia_WCEL".name;
