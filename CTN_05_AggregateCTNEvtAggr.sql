-- COPIE LA TABLE AGGR avec GROUP BY DANS LA TABLE AGGR_TMP
DROP TABLE IF EXISTS ctn_evt_aggr_tmp;

CREATE TABLE ctn_evt_aggr_tmp AS 
SELECT
  evt_name,
  primarycell,
  targetcell,
  initaccesscell,
  psc,
  sum(cpichecno_sum) AS cpichecno_sum,
  mcc,
  mnc,
  lac,
  ci,
  sum(nb_event) AS nb_event
FROM ctn_evt_aggr
GROUP BY
  evt_name,
  primarycell,
  targetcell,
  initaccesscell,
  psc,
  mcc,
  mnc,
  lac,
  ci;

-- VIDE LA TABLE TMP
DROP TABLE IF EXISTS ctn_evt_aggr;

ALTER TABLE ctn_evt_aggr_tmp RENAME TO ctn_evt_aggr;

