SELECT t_voisines_interrnc.RNC, 
t_voisines_interrnc.NeighbourRNC, 
t_voisines_interrnc.NeighbourRNCId, 
t_voisines_interrnc.NbVoisines, 
snap3g_NeighbouringRNC.NeighbouringRNC, 
snap3g_NeighbouringRNC.administrativeState, 
snap3g_NeighbouringRNC.operationalState
FROM t_voisines_interrnc LEFT JOIN snap3g_NeighbouringRNC
 ON t_voisines_interrnc.NeighbourRNCId = snap3g_NeighbouringRNC.NeighbouringRNC
		AND t_voisines_interrnc.RNC = snap3g_NeighbouringRNC.RNC 

WHERE (snap3g_NeighbouringRNC.NeighbouringRNC Is Null AND t_voisines_interrnc.NeighbourRNCId <> '159') -- On enleve le rnc 159 des microcells
	OR snap3g_NeighbouringRNC.operationalState='disabled' --Liste les IUR desabled
ORDER BY t_voisines_interrnc.NbVoisines DESC;
