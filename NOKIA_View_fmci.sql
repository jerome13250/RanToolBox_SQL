﻿SELECT 
  nokia_fmci.managedobject_fmci, 
  nokia_fmci.name, 
  nokia_fmci.ifhocausecpichecno, 
  nokia_fmci.ifhocausecpichrscp, 
  nokia_fmci.ifhocausetxpwrdl, 
  nokia_fmci.ifhocausetxpwrul, 
  nokia_fmci.ifhocauseuplinkquality, 
  nokia_fmci.interfrequetxpwrfiltercoeff, 
  nokia_fmci.interfrequetxpwrthramr, 
  nokia_fmci.interfrequetxpwrthrcs, 
  nokia_fmci.interfrequetxpwrthrnrtps, 
  nokia_fmci.interfrequetxpwrthrrtps, 
  nokia_fmci.interfrequetxpwrtimehyst, 
  nokia_fmci.interfreqdltxpwrthramr, 
  nokia_fmci.interfreqdltxpwrthrcs, 
  nokia_fmci.interfreqdltxpwrthrnrtps, 
  nokia_fmci.interfreqdltxpwrthrrtps, 
  nokia_fmci.interfreqmeasrepinterval
FROM 
  public.nokia_fmci;
