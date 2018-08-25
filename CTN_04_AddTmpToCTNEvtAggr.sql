-- COPIE LA TABLE TMP DANS LA TABLE AGGR
INSERT INTO ctn_evt_aggr 
SELECT
  evt_name,
  primarycell,
  targetcell,
  initaccesscell,
  psc,
  to_number(ctn_evt_tmp.cpichecno, '999') AS cpichecno_sum,
  mcc,
  mnc,
  lac,
  ci,
  nb_event
FROM ctn_evt_tmp;

-- VIDE LA TABLE TMP
TRUNCATE ctn_evt_tmp;

