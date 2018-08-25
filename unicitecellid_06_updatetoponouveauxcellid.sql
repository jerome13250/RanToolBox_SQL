UPDATE t_topologie3g AS topo
  SET cellid = unicite.cellid
  FROM tmp_unicitecellid_05_nouveauxcellid AS unicite
  WHERE topo.fddcell = unicite.fddcell
    --AND topo.cellid IN ('48356','58115')

 ;