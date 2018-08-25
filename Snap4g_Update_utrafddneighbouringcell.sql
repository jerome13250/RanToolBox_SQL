-- Mise en forme RncAccess
UPDATE snap4g_utrafddneighboringcellrelation AS t
 SET 
  rncaccessid = replace(t.rncaccessid,'UtranAccessGroup/0 RncAccess/','')
;
