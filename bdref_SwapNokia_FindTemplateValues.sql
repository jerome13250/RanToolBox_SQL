--CELLPROFILE: 
SELECT 
  t_histo_swap_param_alu.fddcell, 
  t_histo_swap_param_alu.localcellid AS LCID, 
  t_histo_swap_param_alu.cellselectionprofileid AS param_ALU,
  bdref_swapnokia_mappingParamAluTemplate.template_bdref AS template,
  bdref_swapnokia_mappingParamAluTemplate.template_bdref_valeur AS valeur

 
  --t_histo_swap_param_alu.cellselectionwithpriorityprofileid, 
  --t_histo_swap_param_alu.hoconfid, 
  --t_histo_swap_param_alu.alarmprioritytableconfclassid
FROM 
  public.t_histo_swap_param_alu INNER JOIN public.bdref_swapnokia_listcellulesaswapper
  ON 
	t_histo_swap_param_alu.localcellid = bdref_swapnokia_listcellulesaswapper."LCID"
  LEFT JOIN public.bdref_swapnokia_mappingParamAluTemplate
  ON
	t_histo_swap_param_alu.cellselectionprofileid = bdref_swapnokia_mappingParamAluTemplate.parametre_alu



UNION --RESELECTION_LTE: cellselectionwithpriorityprofileid

SELECT 
  t_histo_swap_param_alu.fddcell, 
  t_histo_swap_param_alu.localcellid, 
  t_histo_swap_param_alu.cellselectionwithpriorityprofileid,
  bdref_swapnokia_mappingParamAluTemplate.template_bdref,
  bdref_swapnokia_mappingParamAluTemplate.template_bdref_valeur

 
  --t_histo_swap_param_alu.cellselectionwithpriorityprofileid, 
  --t_histo_swap_param_alu.hoconfid, 
  --t_histo_swap_param_alu.alarmprioritytableconfclassid
FROM 
  public.t_histo_swap_param_alu INNER JOIN public.bdref_swapnokia_listcellulesaswapper
  ON 
	t_histo_swap_param_alu.localcellid = bdref_swapnokia_listcellulesaswapper."LCID"
  LEFT JOIN public.bdref_swapnokia_mappingParamAluTemplate
  ON
	t_histo_swap_param_alu.cellselectionwithpriorityprofileid = bdref_swapnokia_mappingParamAluTemplate.parametre_alu


UNION --hoconfid:MOBILITE_VOIX

SELECT 
  t_histo_swap_param_alu.fddcell, 
  t_histo_swap_param_alu.localcellid, 
  t_histo_swap_param_alu.hoconfid,
  bdref_swapnokia_mappingParamAluTemplate.template_bdref,
  bdref_swapnokia_mappingParamAluTemplate.template_bdref_valeur

 
   --t_histo_swap_param_alu.hoconfid, 
  --t_histo_swap_param_alu.alarmprioritytableconfclassid
FROM 
  public.t_histo_swap_param_alu INNER JOIN public.bdref_swapnokia_listcellulesaswapper
  ON 
	t_histo_swap_param_alu.localcellid = bdref_swapnokia_listcellulesaswapper."LCID"
  LEFT JOIN public.bdref_swapnokia_mappingParamAluTemplate
  ON
	t_histo_swap_param_alu.hoconfid = bdref_swapnokia_mappingParamAluTemplate.parametre_alu
--WHERE
  --template_bdref IS NULL

UNION --TARGET_RAT:alarmprioritytableconfclassid

SELECT 
  t_histo_swap_param_alu.fddcell, 
  t_histo_swap_param_alu.localcellid, 
  t_histo_swap_param_alu.alarmprioritytableconfclassid,
  bdref_swapnokia_mappingParamAluTemplate.template_bdref,
  --Cas particulier, obligé de vérifier un autre paramètre pour l'event 6A :
  CASE 	WHEN (hoconfid='RadioAccessService/0 DedicatedConf/0 HoConfClass/8') THEN '2G_ULTxPwr6A'
	ELSE bdref_swapnokia_mappingParamAluTemplate.template_bdref_valeur END 

  --t_histo_swap_param_alu.alarmprioritytableconfclassid
FROM 
  public.t_histo_swap_param_alu INNER JOIN public.bdref_swapnokia_listcellulesaswapper
  ON 
	t_histo_swap_param_alu.localcellid = bdref_swapnokia_listcellulesaswapper."LCID"
  LEFT JOIN public.bdref_swapnokia_mappingParamAluTemplate
  ON
	t_histo_swap_param_alu.alarmprioritytableconfclassid = bdref_swapnokia_mappingParamAluTemplate.parametre_alu


UNION --MOBILITE_DATA

SELECT 
  t_histo_swap_param_alu.fddcell, 
  t_histo_swap_param_alu.localcellid, 
  ''::text AS param_alu,
  'Mobilite_Data'::text AS template_bdref,
  'IF_Data_18db' AS template_bdref_valeur

FROM 
  public.t_histo_swap_param_alu INNER JOIN public.bdref_swapnokia_listcellulesaswapper
  ON 
	t_histo_swap_param_alu.localcellid = bdref_swapnokia_listcellulesaswapper."LCID"
  

ORDER BY
 template,
 fddcell
 
;
