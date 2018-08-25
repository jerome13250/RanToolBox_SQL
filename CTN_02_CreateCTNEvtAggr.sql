DROP TABLE IF EXISTS ctn_evt_aggr;

CREATE TABLE ctn_evt_aggr
(
  evt_name text,
  primarycell text,
  targetcell text,
  initaccesscell text,
  psc text,
  cpichecno_sum integer,
  mcc text,
  mnc text,
  lac text,
  ci text,
  nb_event integer
)