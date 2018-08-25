SELECT 
  "Paramètre",
  "CLASSEs",
  "CLASSEv",
  "Valeur"
FROM 
  public.bdref_param_vois_nokiaericsson
WHERE
 "Paramètre" ILIKE '%hop%' AND
 "Paramètre" NOT ILIKE 'SRB%'

UNION 

SELECT 
  "Paramètre",
  "CLASSEs",
  "CLASSEv",
  "Valeur"
FROM 
  public.bdref_param_vois_nokianec
WHERE
 "Paramètre" ILIKE '%hop%' AND
 "Paramètre" NOT ILIKE 'SRB%'

UNION 

SELECT 
  "Paramètre",
  "CLASSEs",
  "CLASSEv",
  "Valeur"
FROM 
  public.bdref_param_vois_nokianokia
WHERE
 "Paramètre" ILIKE '%hop%' AND
 "Paramètre" NOT ILIKE 'SRB%'

UNION 

SELECT 
  "Paramètre",
  "CLASSEs",
  "CLASSEv",
  "Valeur"
FROM 
  public.bdref_param_vois_nokianortel
WHERE
"Paramètre" ILIKE '%hop%' AND
 "Paramètre" NOT ILIKE 'SRB%'

UNION 

SELECT 
  "Paramètre",
  "CLASSEs",
  "CLASSEv",
  "Valeur"
FROM 
  public.bdref_param_vois_nokiars
WHERE
 "Paramètre" ILIKE '%hop%' AND
 "Paramètre" NOT ILIKE 'SRB%'

ORDER BY
  
  "CLASSEs",
  "CLASSEv",
  "Paramètre"


;
