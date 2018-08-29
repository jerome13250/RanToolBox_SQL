SELECT DISTINCT
  "nokia_SBTS"."managedObject_distName",
  "nokia_SBTS"."sbtsDescription",
  "nokia_SBTS"."sbtsName",
  "nokia_SBTS"."managedObject_SBTS",
  "nokia_FSM"."inventoryUnitType",
  "nokia_TRM"."inventoryUnitType",

  CASE 
  	WHEN "nokia_ETHLK"."connectorLabel"= '0' THEN 'FSMF_EIF_RJ45 - Full IP'
    WHEN "nokia_ETHLK"."connectorLabel"= '1' THEN 'FSMF_EIF2_SFP - ATM'
    WHEN "nokia_ETHLK"."connectorLabel"= '2' THEN 'EIF2 - ?'
    WHEN "nokia_ETHLK"."connectorLabel"= '3' THEN 'FTIF_EIF3_RJ45 - Full IP'
    WHEN "nokia_ETHLK"."connectorLabel"= '4' THEN 'FTIF_EIF2_SFP - ATM'
    WHEN "nokia_ETHLK"."connectorLabel"= '5' THEN 'FTIF_EIF4_RJ45 - ?'
    ELSE '?'
  END AS Trans


FROM 
  public."nokia_SBTS" INNER JOIN public."nokia_HW"
  ON
  	"nokia_HW"."managedObject_distName_parent" = "nokia_SBTS"."managedObject_distName"
  LEFT JOIN public."nokia_FSM"
  ON
  	"nokia_FSM"."managedObject_distName_parent" = "nokia_HW"."managedObject_distName"
  LEFT JOIN public."nokia_TRM" 
  ON
  	"nokia_TRM"."managedObject_distName_parent" = "nokia_FSM"."managedObject_distName"
  LEFT JOIN public."nokia_TNL"
  ON
    "nokia_SBTS"."managedObject_distName" = "nokia_TNL"."managedObject_distName_parent"
  LEFT JOIN public."nokia_ETHSVC"
  ON
  	"nokia_TNL"."managedObject_distName" = "nokia_ETHSVC"."managedObject_distName_parent"
  LEFT JOIN public."nokia_ETHLK"
  ON
  	"nokia_ETHSVC"."managedObject_distName" = "nokia_ETHLK"."managedObject_distName_parent"
    
--  WHERE "nokia_SBTS"."sbtsName" = 'ST_GERVAIS_TDF'
  
  ORDER BY
    "nokia_SBTS"."sbtsName"   
  ;
  
  


