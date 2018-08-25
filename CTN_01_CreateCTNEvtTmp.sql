DROP TABLE IF EXISTS ctn_evt_tmp;

CREATE TABLE ctn_evt_tmp
(
  traceSessionRef text,
  traceRecSessionRef text,
  stime text,
  evt_name text,
  evt_changetime text,
  callType text,
  primarycell text,
  targetcell text,
  hsxpaInd text,
  initaccesscell text,
  callestabcause text,
  psc text,
  cpichecno text,
  cndomain text,
  systemtype text,
  type text,
  cause text,
  bcch text,
  cellid text,
  mcc text,
  mnc text,
  lac text,
  ci text,
  nasUeIdImsi text,
  nb_event integer
)