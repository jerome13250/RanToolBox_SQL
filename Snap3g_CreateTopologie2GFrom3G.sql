DROP TABLE IF EXISTS t_topologie2gfrom3g;

CREATE TABLE t_topologie2gfrom3g AS

SELECT DISTINCT
  snap3g_gsmcell.gsmcell, 
  snap3g_gsmcell.ci, 
  --snap3g_gsmcell.gsmbandindicator, 
  snap3g_gsmcell.locationareacode, 
  snap3g_gsmcell.mobilecountrycode, 
  snap3g_gsmcell.mobilenetworkcode, 
  snap3g_gsmcell.userspecificinfo
FROM 
  public.snap3g_gsmcell
ORDER BY
  userspecificinfo;
