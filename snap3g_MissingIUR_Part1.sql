DROP TABLE IF EXISTS t_voisines_interrnc;

SELECT snap3g_UMTSFddNeighbouringCell.RNC, 
snap3g_RNC.rncId, 
t_topologie3g.rnc AS NeighbourRNC, 
t_topologie3g.rncId AS NeighbourRNCId, 
COUNT(snap3g_UMTSFddNeighbouringCell.FDDCell) AS NbVoisines, 
t_topologie3g.mobileNetworkCode 
INTO t_voisines_interrnc

FROM snap3g_UMTSFddNeighbouringCell 
INNER JOIN t_topologie3g 
	ON snap3g_UMTSFddNeighbouringCell.UMTSFddNeighbouringCell = t_topologie3g.FDDCell
INNER JOIN snap3g_RNC 
	ON snap3g_UMTSFddNeighbouringCell.RNC = snap3g_RNC.RNC

WHERE t_topologie3g.mobileCountryCode='208'

GROUP BY snap3g_UMTSFddNeighbouringCell.RNC, 
snap3g_RNC.rncId, 
t_topologie3g.rnc, 
t_topologie3g.rncId, 
t_topologie3g.mobileNetworkCode
HAVING (t_topologie3g.rncId<>snap3g_RNC.rncId AND t_topologie3g.mobileNetworkCode='01')
ORDER BY snap3g_UMTSFddNeighbouringCell.RNC,
Count(snap3g_UMTSFddNeighbouringCell.FDDCell) DESC;

