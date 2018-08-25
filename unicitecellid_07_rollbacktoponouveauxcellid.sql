UPDATE t_topologie3g AS topo
  SET cellid = unicite.cellid_old
  FROM tmp_unicitecellid_05_nouveauxcellid AS unicite
  WHERE topo.fddcell = unicite.fddcell
 ;