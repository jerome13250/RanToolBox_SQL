DROP TABLE IF EXISTS t_topo3g_cosector;

CREATE TABLE t_topo3g_cosector AS
SELECT 
  nodeb, 
  fddcell AS fddcell_fdd10,
  sector_number, 
  localcellid AS lcid_fdd10, 
  cellid AS ci_fdd10
FROM 
  public.t_topologie3g
WHERE 
  dlfrequencynumber = '10787'
  AND nodeb != '' --Evite les cellules externes hors RAN
ORDER BY
  fddcell;

  ALTER TABLE t_topo3g_cosector ADD COLUMN fddcell_fdd11 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN lcid_fdd11 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN ci_fdd11 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN fddcell_fdd12 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN lcid_fdd12 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN ci_fdd12 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN fddcell_fdd7 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN lcid_fdd7 TEXT;
  ALTER TABLE t_topo3g_cosector ADD COLUMN ci_fdd7 TEXT;


UPDATE t_topo3g_cosector AS t
 SET 
  fddcell_fdd11 = topo.fddcell,
  lcid_fdd11 = topo.localcellid,
  ci_fdd11 = topo.cellid
  
 FROM 
  public.t_topologie3g AS topo
WHERE 
  t.nodeb = topo.nodeb AND
  t.sector_number = topo.sector_number AND
  topo.dlfrequencynumber = '10812';

UPDATE t_topo3g_cosector AS t
 SET 
  fddcell_fdd12 = topo.fddcell,
  lcid_fdd12 = topo.localcellid,
  ci_fdd12 = topo.cellid
  
 FROM 
  public.t_topologie3g AS topo
WHERE 
  t.nodeb = topo.nodeb AND
  t.sector_number = topo.sector_number AND
  topo.dlfrequencynumber = '10836';

UPDATE t_topo3g_cosector AS t
 SET 
  fddcell_fdd7 = topo.fddcell,
  lcid_fdd7 = topo.localcellid,
  ci_fdd7 = topo.cellid
  
 FROM 
  public.t_topologie3g AS topo
WHERE 
  t.nodeb = topo.nodeb AND
  t.sector_number = topo.sector_number AND
  topo.dlfrequencynumber = '10712';

