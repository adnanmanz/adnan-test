# autovacuum 
https://tomasz-gintowt.medium.com/postgresql-performance-with-pg-stat-io-real-world-use-cases-1ad42e97b3c1

# nested loop
(https://medium.com/@ywkim_40859/nested-loop-join-performance-issue-diagnosis-guide-in-postgresql-4dfb425f1f21)

# PostgreSQL Configurations
https://medium.com/@harshithgowdakt/postgresql-configurations-every-senior-developer-should-know-12c2ff357db3



SELECT DISTINCT
    "PC0"."pzinskey" AS "pzInsKey",
    "PC0"."pyuseridentifier" AS "pyUserIdentifier",
    "PC0"."pyusername" AS "pyUserName",
    "PC0"."pyaccessgroup" AS "pyAccessGroup",
    "PC0"."pyworkgroup" AS "pyWorkGroup",
    "PC0"."pyemailaddress" AS "pyEmailAddress",
    "PC0"."pyorgunit" AS "pyOrgUnit"
FROM
    pegadata.pr_operators "PC0"
    INNER JOIN pegadata.pr_index_operators "ADDAG" ON (((("PC0"."pyuseridentifier" = "ADDAG"."pylabel"
                        AND "PC0"."pxobjclass" = 'Data-Admin-Operator-ID')
                    AND "ADDAG"."pxobjclass" = 'Data-Admin-Operator-ID')))
    UNION
    SELECT DISTINCT
        "UN1"."pzinskey" AS "pzInsKey",
        "UN1"."pyuseridentifier" AS "pyUserIdentifier",
        "UN1"."pyusername" AS "pyUserName",
        "UN1"."pyaccessgroup" AS "pyAccessGroup",
        "UN1"."pyworkgroup" AS "pyWorkGroup",
        "UN1"."pyemailaddress" AS "pyEmailAddress",
        "UN1"."pyorgunit" AS "pyOrgUnit"
    FROM
        pegadata.pr_Group_Data_Oper "UN1"
    INNER JOIN pegadata.pr_index_operators "ADDAG" ON (((("UN1"."pyuseridentifier" = "ADDAG"."pylabel"
                        AND "UN1"."pxobjclass" = 'Data-Admin-Operator-ID')
                    AND "ADDAG"."pxobjclass" = 'Data-Admin-Operator-ID')))
    ORDER BY
        3 ASC


--

autovacum seting
==============

table wise
=
SELECT relname, reloptions FROM pg_class WHERE relname = 'your_table_name';

db level
=====

SELECT * FROM pg_settings WHERE category LIKE 'Autovacuum';

\copy your_table FROM 'local_file.csv' WITH (FORMAT csv, DELIMITER ',');


toast TABLE
=======

SELECT oid::regclass AS main_table_name FROM pg_class WHERE reltoastrelid = 'pg_toast.pg_toast_814033'::regclass;


check bloat and manual vacuum
===============================
Updates, delete and time and now
SELECT relname AS TableName, n_live_tup AS LiveTuples, n_dead_tup AS DeadTuples, n_tup_del, n_tup_upd, last_autovacuum AS Autovacuum, last_vacuum AS ManualVacuum, now() FROM pg_stat_user_tables WHERE relname = 'your_table_name';


total size of table and index
========================
SELECT relname AS object_name, pg_size_pretty(pg_total_relation_size(relid)) AS total_size, pg_size_pretty(pg_relation_size(relid)) AS table_size, pg_size_pretty(pg_indexes_size(relid)) AS index_size FROM pg_catalog.pg_statio_user_tables WHERE relname = 'pr_unilever_fw_plc_data__81f08';


SHOW autovacuum;
SHOW autovacuum_vacuum_threshold;
SHOW autovacuum_vacuum_scale_factor;
SHOW autovacuum_analyze_threshold;
SHOW autovacuum_analyze_scale_factor;
SHOW autovacuum_vacuum_insert_threshold;
SHOW autovacuum_vacuum_insert_scale_factor;
SHOW autovacuum_naptime;


analyze count 
===============



SELECT
    schemaname,
    relname,
    analyze_count,
    autoanalyze_count,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
ORDER BY (analyze_count + autoanalyze_count) DESC;