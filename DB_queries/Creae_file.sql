cloud KE
=========





\copy () to '/EA-D1806.csv' with csv header;

\copy () to '/EA-D1806.csv' with csv header;













cuttyhunk
========


\Copy () To '/local/pega-work/sync-data/full.csv' With CSV DELIMITER ',' HEADER;
\Copy () To '/local/pega-work/sync-data/full.csv' With CSV DELIMITER ',' HEADER;
\Copy () To '/local/pega-work/sync-data/full.csv' With CSV DELIMITER ',' HEADER;
\Copy () To '/local/pega-work/sync-data/full.csv' With CSV DELIMITER ',' HEADER;
\Copy () To '/local/pega-work/sync-data/full.csv' With CSV DELIMITER ',' HEADER;
\Copy () To '/local/pega-work/sync-data/full.csv' With CSV DELIMITER ',' HEADER;
\Copy () To '/local/pega-work/sync-data/full.csv' With CSV DELIMITER ',' HEADER;



cache TABLESPACE
================

truncate table pega85522040023.pr_sys_cache_entry;
truncate table pega85522040023.pr_sys_cache_dep;
truncate table pega85522040023.pr_sys_cache_impl;
truncate table pega85522040023.pr_sys_appcache_dep;
truncate table pega85522040023.pr_sys_appcache_entry;
truncate table pega85522040023.pr_sys_appcache_shortcut;
truncate table pega85522040023.pr_sys_app_hierarchy_flat;
truncate table pega85522040023.pr_sys_app_ruleset_index;
truncate table pega85522040023.pr_sys_ruleset_index;
truncate table pega85522040023.pr_sys_class_ancestors;
truncate table pega85522040023.pr_sys_rule_impl;
truncate table pega85522040023.pr4_rule_sysgen;
truncate table pega85522040023.pr_assembledclasses;
truncate table pegadata.PR_SYS_UPDATESCACHE;
truncate table pega85522040023.pr_sysgen_static_content;
truncate table pegadata.PR_Sys_StatusNodes;
truncate table pegadata.PR_Sys_StatusDetails;











WITH parent_cases AS (
     SELECT
         p.pzInsKey AS parent_inskey,
         p.pyID AS case_id,
         p.pxObjClass AS parent_case_type,
         p.pyLabel AS parent_case_label,
         p.revisionid,
         p.pyStatusWork AS case_final_status,
         p.issueName,
         p.pxApplication,
         p.groupName,
         p.pxCoveredCount,
         p.requestType,
         p.completionDate,
         p.pxUpdateDateTime,
         p.pyResolvedTimestamp,
         p.pyResolvedTime,
         p.pyDescription,
         p.pyStatusWorkTimestamp,
         p.pxCreateDateTime AS case_created_ts
     FROM pegadata.mkt_ops_work p
     WHERE (
             p.pxObjClass = 'PegaMKT-Work-Ops-UpdateAction'
             OR (
                 p.pxObjClass = 'PegaMKT-Work-Ops-ChangeRequest'
                 AND p.requestType = 'Update existing action'
             )
           )
       AND p.pyStatusWork LIKE 'Resolve%'
     ORDER BY p.pxCreateDateTime DESC, p.pyID DESC
     LIMIT 10000
 ),

 child_cases AS (
     SELECT DISTINCT
         pc.case_id,
         pc.parent_inskey,
         c.pzInsKey AS source_inskey,
         c.pyID AS source_case_id,
         c.pxObjClass AS source_case_type,
         c.pyLabel AS source_case_label
     FROM pegadata.mkt_ops_work c
     JOIN parent_cases pc
       ON c.pxCoverInsKey = pc.parent_inskey
     WHERE c.pzInsKey <> pc.parent_inskey
 ),

 parent_raw_events AS (
     SELECT
         pc.case_id,
         pc.parent_inskey,
         pc.parent_inskey AS source_inskey,
         pc.case_id AS source_case_id,
         'PARENT' AS source_level,
         pc.parent_case_type AS source_case_type,
         pc.parent_case_label AS source_case_label,
         h.pxTimeCreated,
         h.pxCommitDateTime,
         COALESCE(h.pxTimeCreated, h.pxCommitDateTime) AS event_ts,
         h.pyAssignedTo,
         h.pyAssignmentClass,
         TRIM(BOTH E'\t' FROM h.pyMessageKey) AS pyMessageKey,
         h.pyMemo,
         h.pyHistoryType,
         h.pyLabel,
         h.pyTaskName,
         h.pyPerformer,
         h.pyFlowName,
         pc.revisionid,
         pc.case_final_status,
         pc.issueName,
         pc.groupName,
         pc.requestType,
         pc.completionDate,
         pc.pxUpdateDateTime,
         pc.pyResolvedTimestamp,
         pc.pyResolvedTime,
         pc.pyStatusWorkTimestamp,
         pc.pxCoveredCount,
         pc.pyDescription,
         pc.pxApplication,
         pc.case_created_ts
     FROM parent_cases pc
     JOIN pegadata.history_mkt_ops_work h
       ON h.pxHistoryForReference = pc.parent_inskey
     WHERE (
             h.pyHistoryType IS NULL
             AND (
                     h.pyMessageKey LIKE '%ItemCreated%'
                  OR h.pyMessageKey LIKE '%StatusChanged%'
                  OR h.pyMessageKey LIKE '%ChangeStage%'
                  OR h.pyMemo LIKE '%ChangeStage%'
                  OR h.pyMessageKey LIKE '%Create new action%'
                  OR h.pyMessageKey LIKE '%Created new changeset%'
                  OR h.pyMessageKey LIKE '%AddedToCover%'
                  OR h.pyMessageKey LIKE '%pyManualChildCaseInsAudit%'
                  OR (
                         h.pyAssignmentClass IS NULL
                         AND (
                                 h.pyMessageKey LIKE '%TaskCompleted%'
                              OR h.pyFlowName = 'GenerateRules'
                             )
                     )
                  OR h.pyTaskName LIKE '%Audit note%'
                 )
           )
        OR h.pyHistoryType IN ('A', 'F', 'L', 'R')
 ),

 child_raw_events AS (
     SELECT
         pc.case_id,
         pc.parent_inskey,
         cc.source_inskey,
         cc.source_case_id,
         'CHILD' AS source_level,
         cc.source_case_type,
         cc.source_case_label,
         h.pxTimeCreated,
         h.pxCommitDateTime,
         COALESCE(h.pxTimeCreated, h.pxCommitDateTime) AS event_ts,
         h.pyAssignedTo,
         h.pyAssignmentClass,
         TRIM(BOTH E'\t' FROM h.pyMessageKey) AS pyMessageKey,
         h.pyMemo,
         h.pyHistoryType,
         h.pyLabel,
         h.pyTaskName,
         h.pyPerformer,
         h.pyFlowName,
         pc.revisionid,
         pc.case_final_status,
         pc.issueName,
         pc.groupName,
         pc.requestType,
         pc.completionDate,
         pc.pxUpdateDateTime,
         pc.pyResolvedTimestamp,
         pc.pyResolvedTime,
         pc.pyStatusWorkTimestamp,
         pc.pxCoveredCount,
         pc.pyDescription,
         pc.pxApplication,
         pc.case_created_ts
     FROM child_cases cc
     JOIN parent_cases pc
       ON pc.parent_inskey = cc.parent_inskey
     JOIN pegadata.history_mkt_ops_work h
       ON h.pxHistoryForReference = cc.source_inskey
     WHERE (
             h.pyHistoryType IS NULL
             AND h.pyMessageKey LIKE '%ItemCreated%'
           )
        OR (
             h.pyHistoryType IS NULL
             AND h.pyFlowName = 'GenerateRules'
           )
        OR (
             h.pyHistoryType IN ('A', 'F')
             AND COALESCE(BTRIM(h.pyTaskName), '') <> ''
             AND NOT (
                         h.pyHistoryType = 'A'
                     AND h.pyAssignmentClass = 'Assign-WorkBasket'
                     AND COALESCE(h.pyMessageKey, '') LIKE '%deferred@pega.com%'
                     )
           )
 ),

 raw_events AS (
     SELECT * FROM parent_raw_events
     UNION ALL
     SELECT * FROM child_raw_events
 ),

 parsed_events AS (
     SELECT
         re.*,

         CASE
             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%ItemCreated%'
                 THEN 'Change request created'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%Create new action%'
                 THEN 'Action created'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%Created new changeset%'
                 THEN 'Revision created'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%AddedToCover%'
                 THEN 'Associated to revision'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%pyManualChildCaseInsAudit%'
                 THEN 'Child case linked'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%StatusChanged%'
                 THEN 'Status change'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND (re.pyMessageKey LIKE '%ChangeStage%' OR re.pyMemo LIKE '%ChangeStage%')
                 THEN 'Stage change'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyTaskName LIKE '%Audit note%'
                 THEN 'Audit note'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyAssignmentClass IS NULL
                  AND re.pyMessageKey LIKE '%TaskCompleted%'
                 THEN 'Child task completed'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyAssignmentClass IS NULL
                  AND re.pyFlowName = 'GenerateRules'
                 THEN 'Generate artifacts'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType = 'A'
                  AND re.pyAssignmentClass = 'Assign-Worklist'
                 THEN COALESCE(NULLIF(re.pyTaskName, ''), 'Assigned work')

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType = 'A'
                  AND re.pyAssignmentClass = 'Assign-WorkBasket'
                  AND re.pyMessageKey LIKE '%deferred@pega.com%'
                 THEN 'Waiting for dependent cases'

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType = 'A'
                  AND re.pyAssignmentClass = 'Assign-WorkBasket'
                 THEN COALESCE(NULLIF(re.pyTaskName, ''), 'Queued work')

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType = 'F'
                 THEN COALESCE(NULLIF(re.pyTaskName, ''), 'Task completed')

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType = 'L'
                 THEN COALESCE(NULLIF(SPLIT_PART(re.pyMessageKey, E'\t', 2), ''), 'Flow event')

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType = 'R'
                 THEN 'Transferred'

             WHEN re.source_level = 'CHILD'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%ItemCreated%'
                 THEN 'Child case created'

             WHEN re.source_level = 'CHILD'
                  AND re.pyHistoryType IS NULL
                  AND re.pyFlowName = 'GenerateRules'
                 THEN 'Generate artifacts'

             WHEN re.source_level = 'CHILD'
                  AND re.pyHistoryType = 'A'
                 THEN COALESCE(NULLIF(re.pyTaskName, ''), 'Assigned work')

             WHEN re.source_level = 'CHILD'
                  AND re.pyHistoryType = 'F'
                 THEN COALESCE(NULLIF(re.pyTaskName, ''), 'Task completed')
         END AS activity_base,

         CASE
             WHEN re.pyHistoryType = 'A' THEN 'start'
             ELSE 'complete'
         END AS lifecycle,

         CASE
             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%StatusChanged%'
                 THEN NULLIF(SPLIT_PART(re.pyMessageKey, E'\t', 2), '')
         END AS target_status,

         CASE
             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%ChangeStage%'
                 THEN NULLIF(SPLIT_PART(re.pyMessageKey, E'\t', 3), '')
             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMemo LIKE '%ChangeStage%'
                 THEN NULLIF(SPLIT_PART(TRIM(BOTH E'\t' FROM re.pyMemo), E'\t', 3), '')
         END AS target_stage,

         CASE
             WHEN re.pyHistoryType = 'A'
                  AND re.pyAssignmentClass = 'Assign-WorkBasket'
                  AND re.pyMessageKey NOT LIKE '%deferred@pega.com%'
                  AND STRPOS(REVERSE(re.pyMessageKey), CHR(9)) > 0
                 THEN REVERSE(
                         SUBSTRING(
                             REVERSE(re.pyMessageKey),
                             1,
                             STRPOS(REVERSE(re.pyMessageKey), CHR(9)) - 1
                         )
                      )
         END AS queue_name,

         CASE
             WHEN re.pyHistoryType = 'A'
                 THEN COALESCE(NULLIF(re.pyAssignedTo, ''), NULLIF(re.pyPerformer, ''))
             ELSE COALESCE(NULLIF(re.pyPerformer, ''), NULLIF(re.pyAssignedTo, ''))
         END AS resource,

         CASE
             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyTaskName LIKE '%Audit note%'
                 THEN re.pyMemo

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%pyManualChildCaseInsAudit%'
                 THEN NULLIF(SPLIT_PART(re.pyMessageKey, E'\t', 3), '')

             WHEN re.source_level = 'PARENT'
                  AND re.pyHistoryType IS NULL
                  AND re.pyMessageKey LIKE '%TaskCompleted%'
                 THEN NULLIF(SPLIT_PART(re.pyMessageKey, E'\t', 2), '')

             WHEN re.source_level = 'CHILD'
                  AND re.pyHistoryType IS NULL
                  AND re.pyFlowName = 'GenerateRules'
                 THEN re.pyFlowName
         END AS activity_detail
     FROM raw_events re
 ),

 stage_flags AS (
     SELECT
         pe.*,

         MAX(
             CASE
                 WHEN pe.source_level = 'PARENT'
                  AND pe.activity_base = 'Stage change'
                  AND pe.target_stage IN ('Build', 'Test', 'Deploy')
                 THEN 1 ELSE 0
             END
         ) OVER (
             PARTITION BY pe.case_id
             ORDER BY
                 pe.event_ts,
                 COALESCE(pe.pxCommitDateTime, pe.event_ts),
                 CASE pe.source_level WHEN 'PARENT' THEN 1 ELSE 2 END,
                 pe.source_case_id
             ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
         ) AS seen_parent_build_or_later,

         MAX(
             CASE
                 WHEN pe.source_level = 'PARENT'
                  AND pe.activity_base = 'Stage change'
                  AND pe.target_stage IN ('Test', 'Deploy')
                 THEN 1 ELSE 0
             END
         ) OVER (
             PARTITION BY pe.case_id
             ORDER BY
                 pe.event_ts,
                 COALESCE(pe.pxCommitDateTime, pe.event_ts),
                 CASE pe.source_level WHEN 'PARENT' THEN 1 ELSE 2 END,
                 pe.source_case_id
             ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
         ) AS seen_parent_test_or_deploy
     FROM parsed_events pe
     WHERE pe.activity_base IS NOT NULL
       AND BTRIM(pe.activity_base) <> ''
 ),

 final_events AS (
     SELECT
         sf.*,
         CASE
             WHEN sf.source_level = 'PARENT'
              AND sf.activity_base = 'Stage change'
              AND sf.target_stage = 'Plan'
              AND COALESCE(sf.seen_parent_build_or_later, 0) = 1
                 THEN 'Return to plan'

             WHEN sf.source_level = 'PARENT'
              AND sf.activity_base = 'Stage change'
              AND sf.target_stage = 'Build'
              AND COALESCE(sf.seen_parent_test_or_deploy, 0) = 1
                 THEN 'Return to build'

             ELSE sf.activity_base
         END AS activity_name
     FROM stage_flags sf
 )

 SELECT
     fe.case_id,
     fe.source_case_id,
     fe.source_level,
     fe.source_case_type,
     fe.source_case_label,

     ROW_NUMBER() OVER (
         PARTITION BY fe.case_id
         ORDER BY
             fe.event_ts,
             COALESCE(fe.pxCommitDateTime, fe.event_ts),
             CASE fe.lifecycle WHEN 'start' THEN 1 ELSE 2 END,
             CASE fe.source_level WHEN 'PARENT' THEN 1 ELSE 2 END,
             fe.source_case_id,
             fe.activity_name,
             COALESCE(fe.pyTaskName, ''),
             COALESCE(fe.target_stage, ''),
             COALESCE(fe.target_status, '')
     ) AS event_order,

     to_char(fe.event_ts::timestamp(2), 'YYYY-MM-DD HH24:MI:SS') || '.' || substring(to_char(fe.event_ts::timestamp(2), 'MS') from 1 for 2) AS event_ts,

     CASE
         WHEN fe.source_level = 'PARENT' THEN 'CR | ' || fe.activity_name
         ELSE 'CA | ' || fe.activity_name
     END AS activity,

     fe.activity_name,
     fe.lifecycle,
     fe.target_stage,
     fe.target_status,
     fe.resource,
     fe.queue_name,
     fe.activity_detail,
     fe.pyTaskName AS task_name,
     fe.pyFlowName AS flow_name,
     fe.pyAssignedTo AS assigned_to,
     fe.pyPerformer AS performed_by,
     fe.pyAssignmentClass AS assignment_class,
     fe.pyMessageKey AS message_key,

     fe.parent_inskey,
     fe.source_inskey,
     fe.requestType,
     fe.issueName,
     fe.groupName,
     fe.pxApplication,
     fe.revisionid,
     to_char(fe.case_created_ts::timestamp(2), 'YYYY-MM-DD HH24:MI:SS') || '.' || substring(to_char(fe.case_created_ts::timestamp(2), 'MS') from 1 for 2) AS case_created_ts,
     to_char(fe.completionDate::timestamp(2), 'YYYY-MM-DD HH24:MI:SS') || '.' || substring(to_char(fe.completionDate::timestamp(2), 'MS') from 1 for 2) AS completionDate,
     to_char(fe.pyResolvedTimestamp::timestamp(2), 'YYYY-MM-DD HH24:MI:SS') || '.' || substring(to_char(fe.pyResolvedTimestamp::timestamp(2), 'MS') from 1 for 2) AS pyResolvedTimestamp,
     fe.pyResolvedTime,
     fe.case_final_status,
     to_char(fe.pyStatusWorkTimestamp::timestamp(2), 'YYYY-MM-DD HH24:MI:SS') || '.' || substring(to_char(fe.pyStatusWorkTimestamp::timestamp(2), 'MS') from 1 for 2) AS pyStatusWorkTimestamp,
     fe.pxCoveredCount,
     fe.pyDescription

 FROM final_events fe
 ORDER BY fe.case_id, event_order;



 SELECT count (*) FROM pca_Booking_CSADT_Work_I_1e903 Where ReasonForInteraction is not null;

SELECT count (*) FROM pca_Booking_CSADT_Work_I_1e903 Where ReasonForInteraction is null;    