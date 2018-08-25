SELECT 
  snap3g_alarmprioritytableconfclass.rnc, 
  snap3g_alarmprioritytableconfclass.radioaccessservice, 
  snap3g_alarmprioritytableconfclass.imcta, 
  snap3g_alarmprioritytableconfclass.alarmprioritytableconfclass, 
  snap3g_alarmprioritytableconfclass.userspecificinfo, 
  t2g.service, 
  t2g.priority AS "2G", 
  tfdd1.priority AS "FDD1",
  tfdd2.priority AS "FDD2",
  tfdd3.priority AS "FDD3",
  tfdd4.priority AS "FDD4",
  tfdd5.priority AS "FDD5"
FROM 
  public.snap3g_alarmprioritytableconfclass 
  INNER JOIN public.snap3g_service t2g
	ON
        snap3g_alarmprioritytableconfclass.rnc = t2g.rnc AND
	snap3g_alarmprioritytableconfclass.alarmprioritytableconfclass = t2g.alarmprioritytableconfclass
  INNER JOIN public.snap3g_service tfdd1
	ON
	t2g.rnc = tfdd1.rnc AND
	t2g.alarmprioritytableconfclass = tfdd1.alarmprioritytableconfclass AND
	t2g.service = tfdd1.service
  INNER JOIN public.snap3g_service tfdd2
	ON
	t2g.rnc = tfdd2.rnc AND
	t2g.alarmprioritytableconfclass = tfdd2.alarmprioritytableconfclass AND
	t2g.service = tfdd2.service
  INNER JOIN public.snap3g_service tfdd3
	ON
	t2g.rnc = tfdd3.rnc AND
	t2g.alarmprioritytableconfclass = tfdd3.alarmprioritytableconfclass AND
	t2g.service = tfdd3.service
  INNER JOIN public.snap3g_service tfdd4
	ON
	t2g.rnc = tfdd4.rnc AND
	t2g.alarmprioritytableconfclass = tfdd4.alarmprioritytableconfclass AND
	t2g.service = tfdd4.service
  INNER JOIN public.snap3g_service tfdd5
	ON
	t2g.rnc = tfdd5.rnc AND
	t2g.alarmprioritytableconfclass = tfdd5.alarmprioritytableconfclass AND
	t2g.service = tfdd5.service
WHERE 

  t2g.frequency = '2G'  AND 
  tfdd1.frequency = 'FDD1' AND 
  tfdd2.frequency = 'FDD2' AND 
  tfdd3.frequency = 'FDD3' AND 
  tfdd4.frequency = 'FDD4' AND 
  tfdd5.frequency = 'FDD5'
LIMIT 500;
