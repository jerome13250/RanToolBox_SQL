SELECT *
FROM public.t_topologie3g_nokia
WHERE "managedObject_WCEL" IN 
	(SELECT 
	"managedObject_WCEL"
	FROM 
	public.t_topologie3g_nokia
	WHERE 
		"WCEL_managedObject_distName" NOT LIKE '%EXUCE%' --on se limite aux doublons intra system Nokia
	GROUP BY 
	"managedObject_WCEL"
	HAVING 
	COUNT("managedObject_WCEL")>1)
ORDER BY
	"managedObject_WCEL",
	name
;
