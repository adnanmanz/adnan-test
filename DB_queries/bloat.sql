
checkoat of tablename
==========================
    SELECT * FROM( SELECT  schemaname, tblname, bs*tblpages AS real_size,pg_size_pretty(pg_total_relation_size(schemaname||'.'||tblname)) As total_table_size,  (tblpages-est_tblpages)*bs AS extra_size, fillfactor, (tblpages-est_tblpages_ff)*bs AS bloat_size,  CASE WHEN tblpages - est_tblpages_ff > 0 THEN 100 * (tblpages - est_tblpages_ff)/tblpages::float ELSE 0 END AS bloat_ratio FROM (SELECT ceil( reltuples / ( (bs-page_hdr)/tpl_size ) ) + ceil( toasttuples / 4 ) AS est_tblpages, ceil( reltuples / ( (bs-page_hdr)*fillfactor/(tpl_size*100) ) ) + ceil( toasttuples / 4 ) AS est_tblpages_ff, tblpages, fillfactor, bs, tblid, schemaname, tblname, heappages, toastpages, is_na FROM (SELECT ( 4 + tpl_hdr_size + tpl_data_size + (2*ma) - CASE WHEN tpl_hdr_size%ma = 0 THEN ma ELSE tpl_hdr_size%ma END - CASE WHEN ceil(tpl_data_size)::int%ma = 0 THEN ma ELSE ceil(tpl_data_size)::int%ma END) AS tpl_size, bs - page_hdr AS size_per_block, (heappages + toastpages) AS tblpages, heappages, toastpages, reltuples, toasttuples, bs, page_hdr, tblid, schemaname, tblname, fillfactor, is_na FROM (SELECT tbl.oid AS tblid, ns.nspname AS schemaname, tbl.relname AS tblname, tbl.reltuples, tbl.relpages AS heappages, coalesce(toast.relpages, 0) AS toastpages, coalesce(toast.reltuples, 0) AS toasttuples, coalesce(substring( array_to_string(tbl.reloptions, ' ') FROM '%fillfactor=#"__#"%' FOR '#')::smallint, 100) AS fillfactor, current_setting('block_size')::numeric AS bs, CASE WHEN version()~'mingw32' OR version()~'64-bit|x86_64|ppc64|ia64|amd64' THEN 8 ELSE 4 END AS ma, 24 AS page_hdr, 23 + CASE WHEN MAX(coalesce(null_frac,0)) > 0 THEN ( 7 + count(*) ) / 8 ELSE 0::int END + CASE WHEN false THEN 4 ELSE 0 END AS tpl_hdr_size, sum( (1-coalesce(s.null_frac, 0)) * coalesce(s.avg_width, 1024) ) AS tpl_data_size, bool_or(att.atttypid = 'pg_catalog.name'::regtype) AS is_na FROM pg_attribute AS att JOIN pg_class AS tbl ON att.attrelid = tbl.oid JOIN pg_namespace AS ns ON ns.oid = tbl.relnamespace JOIN pg_stats AS s ON s.schemaname=ns.nspname AND s.tablename = tbl.relname AND s.inherited=false AND s.attname=att.attname LEFT JOIN pg_class AS toast ON tbl.reltoastrelid = toast.oid WHERE att.attnum > 0 AND NOT att.attisdropped AND tbl.relkind = 'r' GROUP BY 1,2,3,4,5,6,7,8,9,10 ORDER BY 2,3 ) AS s ) AS s2 ) AS s3 ) AS s4 where tblname in('pr_operators');

select sum(octet_length(pzpvstream))/1024/1024/1024 from pegadata.si_work; -- Blob size in GB 


total table size
===============

SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_relation_size(format('%I.%I', schemaname, tablename)::regclass)) AS table_size,
    pg_size_pretty(pg_indexes_size(format('%I.%I', schemaname, tablename)::regclass)) AS index_size,
    pg_size_pretty(pg_total_relation_size(format('%I.%I', schemaname, tablename)::regclass)) AS total_size
FROM pg_tables
WHERE tablename IN (
    'pr_scb_rtimhk_data_aamhkrt'   )
ORDER BY pg_total_relation_size(format('%I.%I', schemaname, tablename)::regclass) DESC;

````

=========

create a file and store the ouput.
=================================

check the queries first 
new or old queries 
¸¸gp2 to gp3 


when temep files is greater than use this 
========================================
set temp_file_limit='-1'; 


top tables
============
SELECT 
    schemaname AS "schema",
    relname AS "table",
    pg_size_pretty(pg_total_relation_size(relid)) AS "total_size",
    pg_size_pretty(pg_relation_size(relid)) AS "table_size",
    pg_size_pretty(pg_indexes_size(relid)) AS "index_size"
FROM 
    pg_catalog.pg_stat_user_tables
ORDER BY 
    pg_total_relation_size(relid) DESC
LIMIT 20;



check  primary key
=========================

SELECT t.relname AS table_name, c.conname AS constraint_name, a.attname AS column_name FROM pg_constraint c JOIN pg_class t ON t.oid = c.conrelid JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(c.conkey) WHERE c.contype = 'p' AND t.relname IN ( 'pr_zatca_bzms_data_fasahdeclar', 'pr_zatca_bzms_data_importerdec', 'pr_zatca_bzms_data_declaration' ) ORDER BY t.relname, a.attname;


check toast table
====


SELECT
    n.nspname AS schema_name,
    c.relname AS table_name,
    t.relname AS toast_table
FROM pg_class c
JOIN pg_namespace n
    ON n.oid = c.relnamespace
JOIN pg_class t
    ON t.oid = c.reltoastrelid
WHERE t.relname = 'pg_toast_2052225';

pg_terminate_backend
========================
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid = '';


check tablename
================
select schemaname, tablename from pg_tables where tablename in ('pr_zatca_bzms_data_importerdec');

select schemaname, tablename from pg_tables where tablename ilike ('pr4_rule');




https://dbaclass.com/article/monitor-sql-queries-in-postgres-using-pg_stat_statements/

running query
==========

SELECT pid, usename, state, TRIM(LEFT(query,140)) AS short_query, wait_event_type, wait_event, xact_start FROM pg_stat_activity WHERE state = 'idle in transaction';

SELECT pid, usename, state, TRIM(LEFT(query,140)) AS short_query, wait_event_type, wait_event, xact_start FROM pg_stat_activity WHERE  state = 'active' ORDER BY state  DESC;


SELECT pid, usename, state, query, wait_event_type, wait_event, xact_start FROM pg_stat_activity WHERE  state = 'active' ORDER BY state  DESC;



index 
==
SELECT
    indexrelname AS index_name,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE relname = 'your_table_name'
ORDER BY pg_relation_size(indexrelid) DESC;




frequncey 
=========
SELECT query, calls, total_exec_time 
FROM pg_stat_statements 
WHERE query ILIKE '%%'
ORDER BY calls DESC;

cehck the aoter ran 
=======

SELECT substring(query FROM 'update table\s+([^\s]+)') AS table_name, SUM(calls), SUM(total_exec_time) AS total_time, TRIM(LEFT(query,140)) AS short_query FROM pg_stat_statements WHERE query ILIKE '%pc_bac_bclmgt_work_gclm%' GROUP BY table_name,query ORDER BY total_time DESC;


✅ 2. Check if INSERT queries ran (from pg_stat_statements)

```
SELECT
    SUM(calls) AS total_insert_queries,
    SUM(total_exec_time) AS total_time,
    query
FROM pg_stat_statements
WHERE query ILIKE 'update pegarules2512.pr_rule%'
GROUP BY query
ORDER BY total_time DESC;

`

select substring(query, 1, 100) AS query, calls, total_exec_time
from pg_stat_statements
order by total_exec_time desc;


CPU intensive queries
====



SELECT  query, round(total_exec_time::numeric, 2) AS total_time, calls, round(mean_exec_time::numeric, 2) AS mean, round((100 * total_exec_time / sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage_cpu FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 1;


SELECT  TRIM(LEFT(query,150)) AS short_query, round(total_exec_time::numeric, 2) AS total_time, calls, round(mean_exec_time::numeric, 2) AS mean, round((100 * total_exec_time / sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage_cpu FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 10;



SELECT  query, round(total_exec_time::numeric, 2) AS total_time, calls, round(mean_exec_time::numeric, 2) AS mean, round((100 * total_exec_time / sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage_cpu FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 10;

SELECT  query, round(total_exec_time::numeric, 2) AS total_time, calls, round(mean_exec_time::numeric, 2) AS mean, round((100 * total_exec_time / sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage_cpu FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 1;



specfic
=========
SELECT pid, now() - query_start AS duration, query, state FROM pg_stat_activity WHERE query ILIKE '%auto_v%' AND state = 'active' AND pid <> pg_backend_pid();




SELECT pid, query FROM pg_stat_activity WHERE state='active' ORDER BY query_start DESC;
;

SELECT  query FROM pg_stat_activity WHERE state='active' ORDER BY query_start DESC ;

create index CONCURRENTLY test on 

script the files
=======================
pega-psql -e -f udf.sql &> udf.log &

psql -e -f reindex.sql &> reindex.log &


total table size 
======

SELECT relname AS table_name, pg_size_pretty(pg_total_relation_size(relid)) AS total_size FROM pg_catalog.pg_statio_user_tables WHERE relname='orders';

find tablename
================
SELECT schemaname, tablename FROM pg_tables WHERE tablename LIKE '%pr_engineclasses%';
SELECT relname AS table_name, pg_size_pretty(pg_total_relation_size(relid)) AS total_size FROM pg_catalog.pg_statio_user_tables WHERE relname like = %data_w%;



tail


Upper CASE
=============
select table_name,column_name from information_schema.columns where column_name ~'[[:upper:]]';


locking
============
SELECT ACTIVITY.PID, ACTIVITY.USENAME, ACTIVITY.QUERY, BLOCKING.PID AS BLOCKING_ID, BLOCKING.QUERY AS BLOCKING_QUERY FROM PG_STAT_ACTIVITY AS ACTIVITY JOIN PG_STAT_ACTIVITY AS BLOCKING ON BLOCKING.PID = ANY(PG_BLOCKING_PIDS(ACTIVITY.PID));



How to identify I/O-intensive queries?
==========================================

SELECT MEAN_EXEC_TIME / 1000 AS MEAN_EXEC_TIME_SECS, CALLS, ROWS, SHARED_BLKS_HIT, SHARED_BLKS_READ, SHARED_BLKS_HIT /(SHARED_BLKS_HIT + SHARED_BLKS_READ)::NUMERIC * 100 AS HIT_RATIO, (BLK_READ_TIME + BLK_WRITE_TIME)/CALLS AS AVERAGE_IO_TIME_MS, QUERY FROM PG_STAT_STATEMENTS WHERE SHARED_BLKS_HIT > 0 ORDER BY (BLK_READ_TIME + BLK_WRITE_TIME)/CALLS DESC limit 10;

How to identify tables with the highest frequency of sequential scans
=====================================================================
SELECT SCHEMANAME, RELNAME, SEQ_SCAN, IDX_SCAN SEQ_TUP_READ, SEQ_TUP_READ / SEQ_SCAN AS AVG_SEQ_READ FROM PG_STAT_ALL_TABLES WHERE SEQ_SCAN > 0 AND SCHEMANAME NOT IN ('pg_catalog','information_schema') ORDER BY AVG_SEQ_READ DESC LIMIT 3;

Guide
-----
https://www.tigerdata.com/learn/5-ways-to-monitor-your-postgresql-database


Post create restore point <restore point>;
========================
SET default_statistics_target=10;
analyze;

VDI access
-------------childcaseid,sender
https://selfservice.vdi.sec.pegacloud.com/


## chekc index size
+++++++++++++++++
SELECT t.relname AS table_name, i.relname AS index_name, pg_size_pretty(pg_relation_size(i.oid)) AS index_size FROM pg_class t JOIN pg_index ix ON t.oid = ix.indrelid JOIN pg_class i ON i.oid = ix.indexrelid WHERE t.relname = 'your_table_name';


SELECT attname, n_distinct, most_common_vals, most_common_freqs
FROM pg_stats
WHERE tablename = 'pc_holman_rulesengine_work'
  AND attname IN ('pxobjclass', 'pystatuswork', 'salesforcecaseid');

check Stats
==

select schemaname, relname, n_live_tup,n_dead_tup,last_vacuum::date, last_autovacuum::date, last_analyze::date, last_autoanalyze::date,n_mod_since_analyze from pg_stat_all_tables where relname in ('');

set temp_file_limit=-1;

Check cardinality
=====

 SELECT COUNT(DISTINCT "PC0"."pxrefobjectkey") AS , COUNT(DISTINCT "PC0"."pxsavedatetime") AS distinct_pxsavedatetime FROM data.pc_data_workattach AS "PC0";



https://msg-viewer.pages.dev/?utm_source=chatgpt.com


table sixe and column_name
================

SELECT relname AS table_name,
       pg_size_pretty(pg_total_relation_size('pegadata.' || relname)) AS total_size
FROM pg_stat_user_tables
WHERE schemaname = 'pegadata'
  AND relname IN (
    'pc_roche_rome_work_contract',
    'pc_history_roche_rome_work_con';
   
)
ORDER BY pg_total_relation_size('pegadata.' || relname) DESC;

idle_trx
+++++++++

SELECT pid, usename, state, query, wait_event_type, wait_event, xact_start FROM pg_stat_activity WHERE state = 'idle in transaction';

select pxjobname,count(*) from pr_log_jobs_scheduler 
where pxjobstatus='Failed' 
and pxcommitdatetime > now() - INTERVAL '7 days' 
group by pxjobname 
having count(*) !=0; 


SELECT * FROM( SELECT  schemaname, tblname, bs*tblpages AS real_size,pg_size_pretty(pg_total_relation_size(schemaname||'.'||tblname)) As total_table_size,  (tblpages-est_tblpages)*bs AS extra_size, fillfactor, (tblpages-est_tblpages_ff)*bs AS bloat_size,  CASE WHEN tblpages - est_tblpages_ff > 0 THEN 100 * (tblpages - est_tblpages_ff)/tblpages::float ELSE 0 END AS bloat_ratio FROM (SELECT ceil( reltuples / ( (bs-page_hdr)/tpl_size ) ) + ceil( toasttuples / 4 ) AS est_tblpages, ceil( reltuples / ( (bs-page_hdr)*fillfactor/(tpl_size*100) ) ) + ceil( toasttuples / 4 ) AS est_tblpages_ff, tblpages, fillfactor, bs, tblid, schemaname, tblname, heappages, toastpages, is_na FROM (SELECT ( 4 + tpl_hdr_size + tpl_data_size + (2*ma) - CASE WHEN tpl_hdr_size%ma = 0 THEN ma ELSE tpl_hdr_size%ma END - CASE WHEN ceil(tpl_data_size)::int%ma = 0 THEN ma ELSE ceil(tpl_data_size)::int%ma END) AS tpl_size, bs - page_hdr AS size_per_block, (heappages + toastpages) AS tblpages, heappages, toastpages, reltuples, toasttuples, bs, page_hdr, tblid, schemaname, tblname, fillfactor, is_na FROM (SELECT tbl.oid AS tblid, ns.nspname AS schemaname, tbl.relname AS tblname, tbl.reltuples, tbl.relpages AS heappages, coalesce(toast.relpages, 0) AS toastpages, coalesce(toast.reltuples, 0) AS toasttuples, coalesce(substring( array_to_string(tbl.reloptions, ' ') FROM '%fillfactor=#"__#"%' FOR '#')::smallint, 100) AS fillfactor, current_setting('block_size')::numeric AS bs, CASE WHEN version()~'mingw32' OR version()~'64-bit|x86_64|ppc64|ia64|amd64' THEN 8 ELSE 4 END AS ma, 24 AS page_hdr, 23 + CASE WHEN MAX(coalesce(null_frac,0)) > 0 THEN ( 7 + count(*) ) / 8 ELSE 0::int END + CASE WHEN false THEN 4 ELSE 0 END AS tpl_hdr_size, sum( (1-coalesce(s.null_frac, 0)) * coalesce(s.avg_width, 1024) ) AS tpl_data_size, bool_or(att.atttypid = 'pg_catalog.name'::regtype) AS is_na FROM pg_attribute AS att JOIN pg_class AS tbl ON att.attrelid = tbl.oid JOIN pg_namespace AS ns ON ns.oid = tbl.relnamespace JOIN pg_stats AS s ON s.schemaname=ns.nspname AND s.tablename = tbl.relname AND s.inherited=false AND s.attname=att.attname LEFT JOIN pg_class AS toast ON tbl.reltoastrelid = toast.oid WHERE att.attnum > 0 AND NOT att.attisdropped AND tbl.relkind = 'r' GROUP BY 1,2,3,4,5,6,7,8,9,10 ORDER BY 2,3 ) AS s ) AS s2 ) AS s3 ) AS s4where tblname in ( 'nyl_suitfw_data_stg_accountposition', 'nyl_suitfw_data_stg_account', 'nyl_suitfw_data_stg_clientcontract', 'nyl_suitfw_data_stg_securitymaster', 'nyl_suitfw_data_stg_accountbalanceinfo', 'nyl_suitfw_data_stg_bookkeepinginfo', 'nyl_suitfw_data_stg_ipeaccountinfo', 'nyl_suitfw_data_stg_accountdetail', 'pr_history_nyl_fw_suitfw_20a19', 'nyl_suitfw_data_stg_accountmaster', 'nyl_tradesurv_acc_party_contract_idx', 'pr_index_nyl_fw_suitfw_data_partyaccountposition', 'nyl_tradesurv_acc_posit_idx', 'nyl_history_sysadmin', 'nyl_sysadmin_queue', 'pc_history_nyl_fw_suitfw_d8640', 'pc_history_nyl_suitfw_work_svc', 'pc_nyl_ssd_suitability_work_svc', 'pc_history_nyl_suitfw_work_int', 'pc_nyl_ssd_suitability_work_int', 'pr_nyl_suitfw_data_audittest', 'pr_nyl_suitfw_data_audittransaction', 'pr_nyl_suitfw_data_auditintegration', 'pr_nyl_suitfw_data_auditinput', 'pr_nyl_suitfw_data_auditrule', 'pr_anzplus_data_apilog' );


===
TOAST and blog

select sum(octet_length(pzpvstream))/1024/1024/1024 from pegadata.pr_gs_fw_mcrdfw_data_history; -- Blob size in GB
select pg_size_pretty(pg_relation_size('pegadata.pr_gs_fw_mcrdfw_data_history'));  -- Table size
select pg_size_pretty(pg_indexes_size('pegadata.pr_gs_fw_mcrdfw_data_history'));   -- Size of all indexes of a table

select
    pcp.relname                                                           as primary_name,
    pcp.relpages                                                          as primary_page_count,
    pcp.relpages * current_setting('block_size')::numeric                 as primary_size,
    pg_size_pretty(pcp.relpages * current_setting('block_size')::numeric) as primary_size_pretty,
    pct.relname                                                           as toast_name,
    pct.relpages                                                          as toast_page_count,
    pct.relpages * current_setting('block_size')::numeric                 as toast_size,
    pg_size_pretty(pct.relpages * current_setting('block_size')::numeric) as toast_size_pretty
from
    pg_class      pcp
    join pg_class pct on pct.oid = pcp.reltoastrelid
where
    pcp.relname = 'pc_data_workattach';


=========































INSERT INTO pe




pysical BLK_READ_TIME
====

SELECT queryid, calls, total_exec_time, mean_exec_time, shared_blks_read, shared_blks_hit, round( 100.0 * shared_blks_hit / NULLIF(shared_blks_hit + shared_blks_read,0),2 ) AS hit_ratio,  TRIM(LEFT(query,150)) AS short_query FROM pg_stat_statements ORDER BY shared_blks_read DESC LIMIT 20;




/home/Wintermute/adnan/testing/connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f "/home/Wintermute/adnan/testing/CC-D39429.sql"  

/home/Wintermute/adnan/testing/connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f "/home/Wintermute/adnan/testing/CC-D39429.sql" \





/home/Wintermute/adnan/testing/connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f "/home/Wintermute/adnan/testing/2.sql" 2>&1 | tee /home/Wintermute/adnan/testing/2.log



/home/Wintermute/adnan/testing/connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f "/home/Wintermute/adnan/testing/2.sql" > /home/Wintermute/adnan/testing/output.csv 2>&1


./connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f 2.sql > 2.csv 2>&1


./connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f /home/Wintermute/adnan/testing/1.sql > /home/Wintermute/adnan/testing/2.csv 2>&1


./connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f "$(pwd)/1.sql" > "$(pwd)/all_output.log" 2>&1


./connect.ksh -c cluster-cfo3z8f6hjg2xwls98slgn4y -n bbausa-prod1 -f "$(pwd)/.sql" > "$(pwd)/all_output.log" 2>&1





 

SELECT count (*) FROM pca_Booking_CSADT_Work_I_1e903 Where ReasonForInteraction is not null;

SELECT count (*) FROM pca_Booking_CSADT_Work_I_1e903 Where ReasonForInteraction is null;

SELECT DISTINCT InteractionType FROM pca_Booking_CSADT_Work_I_1e903;

SELECT count (pyID), reasonforinteraction FROM pca_Booking_CSADT_Work_I_1e903 Where ReasonForInteraction is not null and pxapplication in ('CSADT', 'CSADTMain') group by reasonforinteraction;







