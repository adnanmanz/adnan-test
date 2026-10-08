PG_REPACk
====

Here is the query to find the Toast table for the respective main table 
============

SELECT reltoastrelid::regclass  FROM pg_class  WHERE relname = 'pr_changelog';

https://www.postgresql.org/docs/current/pgstattuple.html

SELECT * FROM pgstattuple('pg_catalog.pg_proc');

CREATE EXTENSION IF NOT EXISTS pgstattuple;


select sum(octet_length(pzpvstream))/1024/1024/1024 from pegadata.pr_operators; -- Blob size in GB 
select pg_size_pretty(pg_relation_size('pegadata.pr_data')); -- Table size 
select pg_size_pretty(pg_indexes_size('data.pr_perf_stats')); -- Size of all indexes of a table 

WAL size*
====
SELECT round(sum(size) / 1024.0 / 1024 / 1024, 2) AS size_gb FROM pg_ls_waldir();

pg_repack 
================================
select pid,query from pg_stat_activity where application_name='pg_repack';
select tablename,schemaname from pg_tables where schemaname='repack';
select event_object_schema,trigger_name,event_manipulation,event_object_table from information_schema.triggers;
==========================


  pg_repack
===========================================
PGOPTIONS="-c temp_file_limit=-1 -c idle_in_transaction_session_timeout=0" /root/pg_repack -h <hostname> -U pega -k pega -t <schemaname>.<tablename> &> repack.log &

PGPASSWORD= PGOPTIONS="-c idle_in_transaction_session_timeout=1d -c temp_file_limit=-1"  ./pg_repack  -h  -U pega -k pega -t pegadata.&>.log &

PGPASSWORD= PGOPTIONS="-c idle_in_transaction_session_timeout=1d -c temp_file_limit=-1"  ./pg_repack  -h  -U pega -k pega -t pegadata.&> repack.log &

"select now();"
PGOPTIONS="-c idle_in_transaction_session_timeout=1d -c temp_file_limit=-1" ./pg_repack -h -U pega -k pega  -t pegadata.pca_tcp_dm_ce_csm_work
echo "PG_REPACK done..!"


repack in GCP
PGPASSWORD='q`nydnt9M2i43.jxb?0:vYqLUSbBsjz,' PGOPTIONS="-c idle_in_transaction_session_timeout=1d" ./pg_repack -h localhost -U postgres -k pega -t data.pc_link_attachment &> repack1.log &


