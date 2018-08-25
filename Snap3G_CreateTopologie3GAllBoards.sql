DROP TABLE IF EXISTS t_topologie3g_allboards;

CREATE TABLE t_topologie3g_allboards AS
(
SELECT 
  snap3g_board.btsequipment, 
  snap3g_board.moduleapplication, 
  snap3g_board.modulename, 
  snap3g_board.moduletype, 
  snap3g_board.modulesubtype
FROM 
  public.snap3g_board

UNION ALL

SELECT 
  snap3g_passivecomponent.btsequipment, 
  snap3g_passivecomponent.moduleapplication, 
  snap3g_passivecomponent.modulename, 
  snap3g_passivecomponent.moduletype, 
  snap3g_passivecomponent.modulesubtype
FROM 
  snap3g_passivecomponent

ORDER BY btsequipment ASC,
modulename ASC
);
