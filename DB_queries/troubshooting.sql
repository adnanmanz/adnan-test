pg_stat_statements --> long runnning query
===





==================


SELECT calls, total_exec_time, rows FROM pg_stat_statements WHERE query ILIKE '%pr_BBA_FW_SIGnet2FW_Data_Reser%'

#To check the number of current active connections, we can query the pg_stat_activity table like so:
=================================

SELECT * FROM pg_stat_activity WHERE state = ‘active’;
SHOW max_connections


autovacuum_vacuum_scale_factor
=============================

Check dead tuple and age
======================
# replace the schemaname.

WITH vbt AS (SELECT setting AS autovacuum_vacuum_threshold FROM pg_settings WHERE name = 'autovacuum_vacuum_threshold'), vsf AS (SELECT setting AS autovacuum_vacuum_scale_factor FROM pg_settings WHERE name = 'autovacuum_vacuum_scale_factor'), fma AS (SELECT setting AS autovacuum_freeze_max_age FROM pg_settings WHERE name = 'autovacuum_freeze_max_age'), sto AS (SELECT opt_oid, split_part(setting, '=', 1) AS param, split_part(setting, '=', 2) AS value FROM (SELECT oid opt_oid, unnest(reloptions) setting FROM pg_class) opt) SELECT '"' || ns.nspname || '"."' || c.relname || '"' AS relation, pg_size_pretty(pg_table_size(c.oid)) AS table_size, age(relfrozenxid) AS xid_age, coalesce(cfma.value::float, autovacuum_freeze_max_age::float) autovacuum_freeze_max_age, (coalesce(cvbt.value::float, autovacuum_vacuum_threshold::float) + coalesce(cvsf.value::float, autovacuum_vacuum_scale_factor::float) * c.reltuples) AS autovacuum_vacuum_tuples, n_dead_tup AS dead_tuples FROM pg_class c JOIN pg_namespace ns ON ns.oid = c.relnamespace JOIN pg_stat_all_tables stat ON stat.relid = c.oid JOIN vbt ON (1 = 1) JOIN vsf ON (1 = 1) JOIN fma ON (1 = 1) LEFT JOIN sto cvbt ON cvbt.param = 'autovacuum_vacuum_threshold' AND c.oid = cvbt.opt_oid LEFT JOIN sto cvsf ON cvsf.param = 'autovacuum_vacuum_scale_factor' AND c.oid = cvsf.opt_oid LEFT JOIN sto cfma ON cfma.param = 'autovacuum_freeze_max_age' AND c.oid = cfma.opt_oid WHERE c.relkind = 'r' AND nspname = 'public' AND (age(relfrozenxid) >= coalesce(cfma.value::float, autovacuum_freeze_max_age::float) OR coalesce(cvbt.value::float, autovacuum_vacuum_threshold::float) + coalesce(cvsf.value::float, autovacuum_vacuum_scale_factor::float) * c.reltuples <= n_dead_tup) ORDER BY age(relfrozenxid) DESC LIMIT 50;

last autovacuum running
=======================

SELECT schemaname, relname, n_live_tup, n_dead_tup, last_autovacuum, last_analyze, autovacuum_count, vacuum_count FROM pg_stat_all_tables WHERE relname = 'pr_unilever_fw_plc_data__81f08';

-- Traditional monitoring query (insufficient)
==============================================
SELECT count(*) as active_connections 
FROM pg_stat_activity 
WHERE state = 'active';

-- Last vacuum and analyze times for all tables
SELECT
    schemaname,
    relname AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    ROUND((n_dead_tup::float / NULLIF(n_live_tup, 0)::float) * 100, 2) AS dead_rows_pct,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;

idle transaction
=================
SELECT pid, usename, application_name, client_addr, state, query, xact_start, state_change
FROM pg_stat_activity
WHERE state = 'idle in transaction';.




CREATE INDEX CONCURRENTLY idx_common_account_ ON data.index_common_contactmethod ("entityid");


SELECT COUNT(DISTINCT carelinkid) AS distinct_carelinkid,COUNT(DISTINCT pystatuswork) AS distinct_pystatuswork, COUNT(DISTINCT recordstatus) AS distinct_recordstatus,COUNT(DISTINCT pxobjclass) AS distinct_pxobjclass FROM data.common_account; 

SELECT COUNT(DISTINCT entityid) AS distinct_entityid,COUNT(DISTINCT pxobjclass) AS distinct_pxobjclass FROM data.index_common_contactmethod;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++