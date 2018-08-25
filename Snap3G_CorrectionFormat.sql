UPDATE 
  public.snap3g_btscell
SET 
  antennaaccesslist = replace(antennaaccesslist,'AntennaAccess/',''),
  associatedfddcell = regexp_replace(associatedfddcell,'.*FDDCell/',''),
  localcellgroupid = replace(localcellgroupid,'LocalCellGroup/','')
  ;

UPDATE 
  public.snap3g_btsequipment
SET
  associatednodeb = regexp_replace(associatednodeb,'.*NodeB/','')
  ;

UPDATE 
  public.snap3g_nodeb
SET
  associatedbtsequipment = regexp_replace(associatedbtsequipment,'BTSEquipment/','')
  ;  

  
UPDATE 
  public.snap3g_umtsfddneighbouringcell
SET 
  umtsneighrelationid = replace(umtsneighrelationid,'UmtsNeighbouring/0 UmtsNeighbouringRelation/','');
  
UPDATE 
  public.snap3g_localcellgroup
SET 
  rfcarrierid = replace(rfcarrierid,'RfCarrier/','');

UPDATE 
  public.snap3g_hsdpaconf
SET 
  hsxparesourceid = replace(hsxparesourceid,'HsXpaResource/','');