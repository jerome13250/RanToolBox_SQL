SELECT 
snap3g_FDDCell.rnc,
snap3g_FDDCell.nodeb,
snap3g_FDDCell.FDDCell,
snap3g_BTSCell.btsequipment,
snap3g_BTSCell.btscell,
snap3g_FDDCell.localCellId,
snap3g_FDDCell.dlFrequencyNumber,
snap3g_BTSCell.AntennaAccessList,
snap3g_FDDCell.maxTxPower,
snap3g_FDDCell.pcpichPower,
snap3g_BTSCell.paRatio,
snap3g_AntennaAccess.tmaAccessType,
snap3g_AntennaAccess.rxCabling,
snap3g_AntennaAccess.externalAttenuationType,
snap3g_AntennaAccess.externalAttenuationDivDl,
snap3g_AntennaAccess.externalAttenuationDivUl,
snap3g_AntennaAccess.externalAttenuationMainDl,
snap3g_AntennaAccess.externalAttenuationMainUl
FROM 	(
	snap3g_FDDCell INNER JOIN snap3g_BTSCell 
	ON 
		snap3g_FDDCell.localCellId = snap3g_BTSCell.localCellId
	)
	INNER JOIN snap3g_AntennaAccess 
		ON (snap3g_BTSCell.AntennaAccessList = snap3g_AntennaAccess.AntennaAccess
			AND snap3g_BTSCell.BTSEquipment = snap3g_AntennaAccess.BTSEquipment)
ORDER BY 
snap3g_FDDCell.FDDCell;