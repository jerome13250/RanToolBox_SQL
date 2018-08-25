UPDATE 
  public.snap3g_btscell
SET 
  antennaaccesslist = replace(antennaaccesslist,'AntennaAccess/','')--,
  --associatedfddcell = replace(substring(associatedfddcell,'FDDCell/.*'),'FDDCell/','')
  ;

UPDATE 
  public.snap3g_umtsfddneighbouringcell
SET 
  umtsneighrelationid = replace(umtsneighrelationid,'UmtsNeighbouring/0 UmtsNeighbouringRelation/','');
  
  
UPDATE 
  public.snap3g_btsequipment
SET 
  associatednodeb = replace(substring(associatednodeb,'NodeB/.*'),'NodeB/','');

