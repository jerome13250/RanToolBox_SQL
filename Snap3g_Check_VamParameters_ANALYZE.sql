--ANALYZE car lenteurs d'exécution dans JAVA
--In order to allow the PostgreSQL query planner to make reasonably informed decisions when optimizing queries, the pg_statistic data
--should be up-to-date for all tables used in the query. Normally the autovacuum daemon will take care of that automatically. But
--if a table has recently had substantial changes in its contents, you might need to do a manual ANALYZE rather than wait for autovacuum
-- to catch up with the changes

ANALYZE snap3g_btsequipment;
ANALYZE snap3g_hsxparesource; 
ANALYZE snap3g_btscell;
ANALYZE bdref_t_topologie; 
ANALYZE snap3g_fddcell;
ANALYZE snap3g_vamparameters;
ANALYZE snap3g_localcellgroup;
ANALYZE snap3g_rfcarrier;

