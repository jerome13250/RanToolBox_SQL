UPDATE t_topologie3g AS topo
  SET codenidt = t_nodeb_codenidt.codenidt
  FROM (
	SELECT Distinct
	  t_topologie3g.nodeb, 
	  t_topologie3g.codenidt
	FROM 
	  public.t_topologie3g
	WHERE
	  codenidt IS NOT NULL AND
	  nodeb IS NOT NULL
	) AS t_nodeb_codenidt
  WHERE 
	topo.nodeb = t_nodeb_codenidt.nodeb AND
	topo.codenidt IS NULL;