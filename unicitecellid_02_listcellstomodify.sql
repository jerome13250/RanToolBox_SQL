DROP TABLE IF EXISTS tmp_unicitecellid_02_listcellstomodify;
CREATE TABLE tmp_unicitecellid_02_listcellstomodify AS

SELECT 
  t_ranked.*,
  row_number() OVER () as rownumber --permet de lister les cellid pour faire la jointure avec les cellid libres
  
FROM (
	SELECT 
	t.*,
	ROW_NUMBER() OVER (PARTITION BY cellid ORDER BY info DESC, fddcell ASC) AS ranking --permet de ranker les cellid 
	FROM 
	public.tmp_unicitecellid_01_listcellsdoubles AS t
      ) AS t_ranked
WHERE 
	ranking !=1 AND
	info != 'swap_nokia' AND  --Les cellid NOKIA ne doivent pas être modifiés
	rnc NOT LIKE 'RS\_%' AND  --Les cellid RS ne doivent pas être modifiés
	rnc NOT LIKE 'BACKUP_A'   --BACKUP est un faux RNC
	
	--Filtrage sur les lcids ciblés:
	--AND localcellid IN ('417763')
	
;


	

