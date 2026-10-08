

 set temp_file_limit=-1;
 set maintenance_work_mem='10GB';
 set idle_in_transaction_session_timeout=0;

-- first query
create index concurrently test on pr_wc_data_servicepayloadpxSaveDateTime;



DO $$
DECLARE
batch_size INTEGER := 100000;
total_deleted INTEGER := 0;
rows_deleted INTEGER;
BEGIN
LOOP
DELETE FROM pegadata.pr_wc_data_servicepayload where pzinskey in select pzinskey from pegadata.pr_wc_data_servicepayload WHERE pxSaveDateTime < '20260705T000000.000 GMT' LIMIT batch_size ;
GET DIAGNOSTICS rows_deleted = ROW_COUNT;
total_deleted := total_deleted + rows_deleted;
RAISE NOTICE 'Total rows: % Rows deleted: %', total_deleted,rows_deleted;
IF rows_deleted = 0 THEN
EXIT;
END IF;
COMMIT;
END LOOP;
RAISE NOTICE 'Total records deleted: %', total_deleted;
END $$;

-- seond query 

create index concurrently test1 on pr_perf_statspxCommitDateTime;

DO $$
DECLARE
batch_size INTEGER := 100000;
total_deleted INTEGER := 0;
rows_deleted INTEGER;
BEGIN
LOOP
DELETE FROM pegadata.pr_perf_stats where pzinskey in select pzinskey from pegadata.pr_perf_stats WHERE pxCommitDateTime < '20260705T000000.000 GMT' LIMIT batch_size ;
GET DIAGNOSTICS rows_deleted = ROW_COUNT;
total_deleted := total_deleted + rows_deleted;
RAISE NOTICE 'Total rows: % Rows deleted: %', total_deleted,rows_deleted;
IF rows_deleted = 0 THEN
EXIT;
END IF;
COMMIT;
END LOOP;
RAISE NOTICE 'Total records deleted: %', total_deleted;
END $$;


--- third query 


DO $$
DECLARE
batch_size INTEGER := 100000;
total_deleted INTEGER := 0;
rows_deleted INTEGER;
BEGIN
LOOP
DELETE FROM pegadata.pc_history_wc_pow_work where pzinskey in select pzinskey from pegadata.pc_history_wc_pow_work WHERE pxtimecreated < '20231231T000000.000 GMT' LIMIT batch_size ;
GET DIAGNOSTICS rows_deleted = ROW_COUNT;
total_deleted := total_deleted + rows_deleted;
RAISE NOTICE 'Total rows: % Rows deleted: %', total_deleted,rows_deleted;
IF rows_deleted = 0 THEN
EXIT;
END IF;
COMMIT;
END LOOP;
RAISE NOTICE 'Total records deleted: %', total_deleted;
END $$;















--------------------







DO $$
DECLARE
batch_size INTEGER := 100000;
total_deleted INTEGER := 0;
rows_deleted INTEGER;
BEGIN
LOOP
DELETE FROM data.pr_FORDRPA_Uptime_Data_Staging where pzinskey in select pzinskey from data.pr_FORDRPA_Uptime_Data_Staging where castpxcreatedatetime as date <= castNOW - INTERVAL '7 days' as date LIMIT batch_size;
GET DIAGNOSTICS rows_deleted = ROW_COUNT;
total_deleted := total_deleted + rows_deleted;
RAISE NOTICE 'Rows deleted: %', rows_deleted;
RAISE NOTICE 'So far Total records deleted: %', total_deleted;
IF rows_deleted = 0 THEN
EXIT;
END IF;
COMMIT;
END LOOP;
RAISE NOTICE 'Total records deleted: %', total_deleted;
END $$;



to check the total count 
========

grep "Rows deleted:" CC-D11794.log | awk '{sum+=$NF} END {print sum}'

grep "Rows deleted: 100000" CC-D11794.log | wc -l


DO $$
DECLARE
batch_size INTEGER := 100000;
total_deleted INTEGER := 0;
rows_deleted INTEGER;
BEGIN
LOOP
DELETE FROM data.pr_perf_stats where pzinskey in select pzinskey from data.pr_perf_stats where pxsnapshottime < 'CURRENT_TIMESTAMP - INTERVAL '7' DAY'  LIMIT batch_size;
GET DIAGNOSTICS rows_deleted = ROW_COUNT;
total_deleted := total_deleted + rows_deleted;
RAISE NOTICE 'Rows deleted: %', rows_deleted;
IF rows_deleted = 0 THEN
EXIT;
END IF;
COMMIT;
END LOOP;
RAISE NOTICE 'Total records deleted: %', total_deleted;
END $$;


==



select now ;

set maintenance_work_mem='10GB';

-- Generate DDL of the indexes and paste in cc:

SELECT schemaname,
tablename,
indexname,
indexdef
FROM pg_indexes
WHERE schemaname = 'pegadata'
AND indexname IN 
'hist_insname_6ba24_50179',
'hist_insname_799e3_94766',
'hist_insname_799e3_7388c',
'hist_insname_799e3_7388c_bkp',
'pr_history_idx27c461_bkp',
'history_disp_completeassign_bkp'

ORDER BY indexname;


-- Use drop index concurrently to drop following indexes:

drop index concurrently  hist_insname_6ba24_50179;
drop index concurrently  hist_insname_799e3_94766;
drop index concurrently  hist_insname_799e3_7388c;
drop index concurrently  hist_insname_799e3_7388c_bkp;
drop index concurrently  pr_history_idx27c461_bkp;
drop index concurrently  history_disp_completeassign_bkp;