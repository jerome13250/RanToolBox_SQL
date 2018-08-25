SELECT 
  "nokia_EXGCE"."managedObject_EXGCE", 
  "nokia_EXGCE"."cellIdentity", 
  "nokia_EXGCE".lac, 
  "nokia_EXGCE"."bcchFrequency", 
  "nokia_EXGCE".bcc, 
  "nokia_EXGCE".ncc, 
  "nokia_EXGCE".mnc, 
  "nokia_EXGCE".mcc, 
  "nokia_EXGCE".rac, 
  t_topologie2g."CellName", 
  t_topologie2g."CellInstanceIdentifier", 
  t_topologie2g."AdministrativeState", 
  t_topologie2g."OperationalState", 
  t_topologie2g."AvailabilityStatus", 
  t_topologie2g."AlignmentStatus", 
  t_topologie2g."AlignmentStatusCause", 
  t_topologie2g."BCCHFrequency", 
  t_topologie2g.ncc, 
  t_topologie2g.bcc
FROM 
  public."nokia_EXGCE" INNER JOIN public.t_topologie2g
  ON 
  "nokia_EXGCE"."cellIdentity" = t_topologie2g.ci AND
  "nokia_EXGCE".lac = t_topologie2g.lac
WHERE
  "nokia_EXGCE"."bcchFrequency" != t_topologie2g."BCCHFrequency" OR
  "nokia_EXGCE".bcc != t_topologie2g.bcc OR 
  "nokia_EXGCE".ncc != t_topologie2g.ncc
  --"nokia_EXGCE"."cellIdentity" = '4077'