SELECT 
  nokia_fmcs.managedobject_fmcs,
  nokia_fmcs.name,
  string_agg(replace(nokia_fmcs.managedobject_distname_parent,'PLMN-PLMN/RNC-',''),'-') AS rnc_list,
  count (nokia_fmcs.managedobject_distname_parent) AS nb_rnc,
  --nokia_fmcs.fmcschangeorigin, 
  nokia_fmcs.dsrepbasedsho, 
  nokia_fmcs.ecnofiltercoefficient, 
  nokia_fmcs.activesetweightingcoefficient, 
  nokia_fmcs.additionwindow, 
  nokia_fmcs.additiontime, 
  nokia_fmcs.additionreportinginterval, 
  nokia_fmcs.dropwindow,
  nokia_fmcs.droptime,
  nokia_fmcs.dropreportinginterval, 
  nokia_fmcs.replacementwindow,
  nokia_fmcs.replacementtime,
  nokia_fmcs.replacementreportinginterval, 

  --IFHO et ISHO
  --Event 1F:
  nokia_fmcs.hhoecnothreshold,
  nokia_fmcs.hhoecnotimehysteresis, 
  nokia_fmcs.hhorscpthreshold, 
  nokia_fmcs.hhorscptimehysteresis, 
  --Event 1E:
  nokia_fmcs.hhoecnocancel, 
  nokia_fmcs.hhoecnocanceltime, 
  nokia_fmcs.hhorscpcancel, 
  nokia_fmcs.hhorscpcanceltime, 

  --???:
  nokia_fmcs.hhorscpfiltercoefficient, 
  nokia_fmcs.edchaddecnooffset, 
  nokia_fmcs.edchremecnooffset,   
  
  nokia_fmcs.imsibasedsho, 
  nokia_fmcs.maxactivesetsize
FROM 
  public.nokia_fmcs
GROUP BY 
nokia_fmcs.managedobject_fmcs, 
  nokia_fmcs.dsrepbasedsho, 
  nokia_fmcs.ecnofiltercoefficient, 
  nokia_fmcs.activesetweightingcoefficient, 
  nokia_fmcs.additionwindow, 
  nokia_fmcs.additiontime, 
  nokia_fmcs.additionreportinginterval, 
  nokia_fmcs.dropwindow,
  nokia_fmcs.droptime,
  nokia_fmcs.dropreportinginterval, 
  nokia_fmcs.replacementwindow,
  nokia_fmcs.replacementtime,
  nokia_fmcs.replacementreportinginterval, 
  nokia_fmcs.edchaddecnooffset, 
  nokia_fmcs.edchremecnooffset, 
  --nokia_fmcs.fmcschangeorigin, 
  nokia_fmcs.hhoecnocancel, 
  nokia_fmcs.hhoecnocanceltime, 
  nokia_fmcs.hhoecnothreshold, 
  nokia_fmcs.hhoecnotimehysteresis, 
  nokia_fmcs.hhorscpcancel, 
  nokia_fmcs.hhorscpcanceltime, 
  nokia_fmcs.hhorscpfiltercoefficient, 
  nokia_fmcs.hhorscpthreshold, 
  nokia_fmcs.hhorscptimehysteresis, 
  nokia_fmcs.imsibasedsho, 
  nokia_fmcs.maxactivesetsize,  
  nokia_fmcs.name
ORDER BY
  nokia_fmcs.managedobject_fmcs::int ASC,
  count (nokia_fmcs.managedobject_distname_parent) DESC;
