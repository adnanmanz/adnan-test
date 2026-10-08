ITH bloat AS (
    SELECT *
    FROM (
        SELECT
            schemaname,
            tblname,
            tblid,
            pg_total_relation_size((schemaname || '.' || tblname)::regclass) AS total_table_bytes,
            fillfactor,
            (tblpages - est_tblpages_ff) * bs AS bloat_size,
            CASE
                WHEN tblpages - est_tblpages_ff > 0
                    THEN 100 * (tblpages - est_tblpages_ff) / tblpages::float
                ELSE 0
            END AS bloat_ratio
        FROM (
            SELECT
                ceil(reltuples / (((bs - page_hdr) / tpl_size))) + ceil(toasttuples / 4) AS est_tblpages,
                ceil(reltuples / (((bs - page_hdr) * fillfactor / (tpl_size * 100)))) + ceil(toasttuples / 4) AS est_tblpages_ff,
                tblpages, fillfactor, bs, tblid, schemaname, tblname, heappages, toastpages, is_na
            FROM (
                SELECT
                    (4 + tpl_hdr_size + tpl_data_size + (2 * ma)
                     - CASE WHEN tpl_hdr_size % ma = 0 THEN ma ELSE tpl_hdr_size % ma END
                     - CASE WHEN ceil(tpl_data_size)::int % ma = 0 THEN ma ELSE ceil(tpl_data_size)::int % ma END) AS tpl_size,
                    bs - page_hdr AS size_per_block,
                    (heappages + toastpages) AS tblpages,
                    heappages, toastpages, reltuples, toasttuples, bs, page_hdr,
                    tblid, schemaname, tblname, fillfactor, is_na
                FROM (
                    SELECT
                        tbl.oid AS tblid,
                        ns.nspname AS schemaname,
                        tbl.relname AS tblname,
                        tbl.reltuples,
                        tbl.relpages AS heappages,
                        coalesce(toast.relpages, 0) AS toastpages,
                        coalesce(toast.reltuples, 0) AS toasttuples,
                        coalesce(
                            substring(array_to_string(tbl.reloptions, ' ') FROM '%fillfactor=#"__#"%' FOR '#')::smallint,
                            100
                        ) AS fillfactor,
                        current_setting('block_size')::numeric AS bs,
                        CASE
                            WHEN version() ~ 'mingw32' OR version() ~ '64-bit|x86_64|ppc64|ia64|amd64' THEN 8
                            ELSE 4
                        END AS ma,
                        24 AS page_hdr,
                        23 + CASE
                                WHEN MAX(coalesce(null_frac, 0)) > 0 THEN (7 + count(*)) / 8
                                ELSE 0::int
                             END
                           + CASE WHEN false THEN 4 ELSE 0 END AS tpl_hdr_size,
                        sum((1 - coalesce(s.null_frac, 0)) * coalesce(s.avg_width, 1024)) AS tpl_data_size,
                        bool_or(att.atttypid = 'pg_catalog.name'::regtype) AS is_na
                    FROM pg_attribute att
                    JOIN pg_class tbl ON att.attrelid = tbl.oid
                    JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
                    JOIN pg_stats s
                      ON s.schemaname = ns.nspname
                     AND s.tablename = tbl.relname
                     AND s.inherited = false
                     AND s.attname = att.attname
                    LEFT JOIN pg_class toast ON tbl.reltoastrelid = toast.oid
                    WHERE att.attnum > 0
                      AND NOT att.attisdropped
                      AND tbl.relkind = 'r'
                    GROUP BY 1,2,3,4,5,6,7,8,9,10
                ) s
            ) s2
        ) s3
    ) s4
    WHERE (schemaname, tblname) IN (
        SELECT n.nspname, c.relname
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_stat_user_tables psut ON psut.relid = c.oid
        ORDER BY pg_total_relation_size(c.oid) DESC
        LIMIT 20
    )
)
SELECT
    b.schemaname,
    b.tblname,
    pg_size_pretty(b.total_table_bytes) AS total_table_size,
    b.fillfactor,
    pg_size_pretty(b.bloat_size::bigint) AS bloat_size,
    round(b.bloat_ratio::numeric, 2) AS bloat_ratio,
    pg_table_size(b.tblid) - pg_relation_size(b.tblid) AS toasted_data_bytes,
    pg_size_pretty(pg_table_size(b.tblid) - pg_relation_size(b.tblid)) AS toasted_data_size
FROM bloat b
ORDER BY b.total_table_bytes DESC;