DROP TABLE IF EXISTS t_temp_nisc_rnlbasebandtransceiver;
CREATE TABLE t_temp_nisc_rnlbasebandtransceiver AS
SELECT 
  *,
  regexp_replace(regexp_replace(nisc_rnlbasebandtransceiver."RnlBasebandTransceiverInstanceIdentifier", '{ cell ', '', 'g'), ', bbtRdn .*}', '', 'g') AS rnlcellid
FROM 
  public.nisc_rnlbasebandtransceiver;

  
DROP TABLE IF EXISTS t_topologie2g_trx;
CREATE TABLE t_topologie2g_trx AS
SELECT 
  t_topologie2g."BSCName", 
  t_topologie2g."SiteName",
  t_topologie2g."codeOMC",
  t_topologie2g."SiteID", 
  t_topologie2g."CellName", 
  t_topologie2g."CellInstanceIdentifier",
  t_topologie2g."FrequencyRange",
  t_topologie2g."MobileAllocation",
  t_temp_nisc_rnlbasebandtransceiver."RnlBasebandTransceiverInstanceIdentifier", 
  t_temp_nisc_rnlbasebandtransceiver."Rank", 
  t_temp_nisc_rnlbasebandtransceiver."confTS0", 
  t_temp_nisc_rnlbasebandtransceiver."confTS1", 
  t_temp_nisc_rnlbasebandtransceiver."confTS2", 
  t_temp_nisc_rnlbasebandtransceiver."confTS3", 
  t_temp_nisc_rnlbasebandtransceiver."confTS4", 
  t_temp_nisc_rnlbasebandtransceiver."confTS5", 
  t_temp_nisc_rnlbasebandtransceiver."confTS6", 
  t_temp_nisc_rnlbasebandtransceiver."confTS7", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS0", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS1", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS2", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS3", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS4", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS5", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS6", 
  t_temp_nisc_rnlbasebandtransceiver."nonhoppingTS7", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS0", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS1", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS2", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS3", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS4", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS5", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS6", 
  t_temp_nisc_rnlbasebandtransceiver."maioTS7", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS0", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS1", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS2", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS3", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS4", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS5", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS6", 
  t_temp_nisc_rnlbasebandtransceiver."hopGroupTS7"
FROM 
  public.t_topologie2g LEFT JOIN public.t_temp_nisc_rnlbasebandtransceiver
  ON 
	t_topologie2g."CellInstanceIdentifier" = t_temp_nisc_rnlbasebandtransceiver.rnlcellid
ORDER BY
  t_topologie2g."CellName" ASC,
  t_temp_nisc_rnlbasebandtransceiver."Rank";
