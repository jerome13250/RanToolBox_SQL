DROP TABLE IF EXISTS ctn_evt_ho3g2gfailure;

CREATE TABLE ctn_evt_ho3g2gfailure AS
SELECT 
  cea1.tracesessionref, 
  cea1.tracerecsessionref, 
  cea1.stime, 
  cea1.evt_name as evt_failure,
  cea1.evt_changetime AS cea1_changetime,
  cea2.evt_name AS evt_ho,
  cea2.evt_changetime AS cea2_changetime,
  to_number(cea1.evt_changetime,'999999.999')-to_number(cea2.evt_changetime,'999999.999') AS changetimedifference, 
  cea1.primarycell, 
  cea2.mcc, 
  cea2.mnc, 
  cea2.lac, 
  cea2.ci, 
  cea1.nb_event
FROM 
  public.ctn_evt_tmp AS cea1 INNER JOIN public.ctn_evt_tmp AS cea2
  ON   	cea1.tracesessionref = cea2.tracesessionref AND
	cea1.tracerecsessionref = cea2.tracerecsessionref AND
	cea1.primarycell = cea2.primarycell
WHERE 
  cea1.evt_name LIKE 'CTN_EVENT_3G2G_INTERRAT_HO_%_FAILURE' AND
  cea2.evt_name LIKE 'CTN_EVENT_3G2G_INTERRAT_HO_%S' AND
  to_number(cea1.evt_changetime,'999999.999')-to_number(cea2.evt_changetime,'999999.999') >=0;

 
-- CREATION D'UNE VERSION GROUPE AVEC LE MIN DE TIME DIFFERENCE
DROP TABLE IF EXISTS ctn_evt_ho3g2gfailure_grouped;

CREATE TABLE ctn_evt_ho3g2gfailure_grouped AS
SELECT 
  ctn_evt_ho3g2gfailure.tracesessionref, 
  ctn_evt_ho3g2gfailure.tracerecsessionref, 
  ctn_evt_ho3g2gfailure.stime,
  ctn_evt_ho3g2gfailure.primarycell,  
  ctn_evt_ho3g2gfailure.evt_ho, 
  ctn_evt_ho3g2gfailure.evt_failure, 
  ctn_evt_ho3g2gfailure.cea1_changetime, 
  min(ctn_evt_ho3g2gfailure.changetimedifference) AS changetimedifference
FROM 
  public.ctn_evt_ho3g2gfailure
GROUP BY
  ctn_evt_ho3g2gfailure.tracesessionref, 
  ctn_evt_ho3g2gfailure.tracerecsessionref, 
  ctn_evt_ho3g2gfailure.stime,
  ctn_evt_ho3g2gfailure.primarycell, 
  ctn_evt_ho3g2gfailure.evt_ho, 
  ctn_evt_ho3g2gfailure.evt_failure, 
  ctn_evt_ho3g2gfailure.cea1_changetime;


-- MISE A JOUR DE CTN_EVT_tmp
UPDATE ctn_evt_tmp
 SET 
  mcc = ctn_evt_ho3g2gfailure.mcc, 
  mnc = ctn_evt_ho3g2gfailure.mnc,
  lac = ctn_evt_ho3g2gfailure.lac,
  ci = ctn_evt_ho3g2gfailure.ci
FROM 
  public.ctn_evt_ho3g2gfailure, 
  public.ctn_evt_ho3g2gfailure_grouped
WHERE 
  ctn_evt_tmp.tracesessionref = ctn_evt_ho3g2gfailure.tracesessionref AND
  ctn_evt_tmp.tracerecsessionref = ctn_evt_ho3g2gfailure.tracerecsessionref AND
  ctn_evt_tmp.stime = ctn_evt_ho3g2gfailure.stime AND
  ctn_evt_tmp.evt_name = ctn_evt_ho3g2gfailure.evt_failure AND
  ctn_evt_tmp.evt_changetime = ctn_evt_ho3g2gfailure.cea1_changetime AND
  ctn_evt_ho3g2gfailure.tracesessionref = ctn_evt_ho3g2gfailure_grouped.tracesessionref AND
  ctn_evt_ho3g2gfailure.tracerecsessionref = ctn_evt_ho3g2gfailure_grouped.tracerecsessionref AND
  ctn_evt_ho3g2gfailure.stime = ctn_evt_ho3g2gfailure_grouped.stime AND
  ctn_evt_ho3g2gfailure.primarycell = ctn_evt_ho3g2gfailure_grouped.primarycell AND
  ctn_evt_ho3g2gfailure.primarycell = ctn_evt_tmp.primarycell AND
  ctn_evt_ho3g2gfailure.evt_failure = ctn_evt_ho3g2gfailure_grouped.evt_failure AND
  ctn_evt_ho3g2gfailure.cea1_changetime = ctn_evt_ho3g2gfailure_grouped.cea1_changetime AND
  ctn_evt_ho3g2gfailure.changetimedifference = ctn_evt_ho3g2gfailure_grouped.changetimedifference;

  
  DROP TABLE IF EXISTS ctn_evt_ho3g2gfailure;
  DROP TABLE IF EXISTS ctn_evt_ho3g2gfailure_grouped;