SELECT 
  snap4g_ret.enbequipment, 
  snap4g_ret.ret, 
  snap4g_ret.antennamodelnumber, 
  snap4g_ret.fruid, 
  snap4g_ret.fruidhostrfm, 
  snap4g_ret.mechanicaltilt, 
  snap4g_ret.retalduniquename, 
  snap4g_ret.retfriendlyname, 
  snap4g_ret.retmanagingenodeb, 
  snap4g_ret.retselftest, 
  snap4g_ret.retsoftwarefilename, 
  snap4g_ret.retsoftwarefilenamenew, 
  snap4g_ret.retsoftwareupgradeinprogress, 
  snap4g_ret.rettype, 
  snap4g_retsubunit.retsubunit, 
  snap4g_retsubunit.antennabandclass, 
  snap4g_retsubunit.antennacalibrate, 
  snap4g_retsubunit.antennaconfigfile, 
  snap4g_retsubunit.antennaconfigfilenew, 
  snap4g_retsubunit.antennaelectricaltilt, 
  snap4g_retsubunit.configfileupgradeinprogress, 
  snap4g_retsubunit.labelassociatedenb, 
  snap4g_retsubunit.labelsectorid, 
  snap4g_retsubunit.maxelectricaltilt, 
  snap4g_retsubunit.mechanicaltilt, 
  snap4g_retsubunit.minelectricaltilt, 
  snap4g_retsubunit.remotecellid, 
  snap4g_retsubunit.retsubunitassociatedenodeb, 
  snap4g_retsubunit.retsubunitnumber, 
  snap4g_retsubunit.sectorid
FROM 
  public.snap4g_ret INNER JOIN public.snap4g_retsubunit
	ON snap4g_ret.enbequipment = snap4g_retsubunit.enbequipment AND
	snap4g_ret.ret = snap4g_retsubunit.ret
WHERE 
  snap4g_ret.retfriendlyname !~* 'RET_S._(LTE2600|LTE800|UMTS900|UMTS2100|GSM900|GSM1800)' AND 
  snap4g_ret.retfriendlyname !~* '.*util.*'
ORDER BY
  snap4g_ret.enbequipment;
