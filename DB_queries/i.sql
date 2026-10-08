\copy (
SELECT * FROM (
    WITH case_table AS
    (
        SELECT  
                pyid                             ,
                pzinskey                         ,
                pystatuswork                     ,
                pxcreatedatetime                 ,
                pydescription                    ,
                pyeffortactual                   ,
                pyeffortestimate                 ,
                pyeffortestimatetimestamp        ,
                pyreopencount                    ,
                pyreopentimestamp                ,
                pyresolutioncomplexity           ,
                pyresolutioncost                 ,
                pyresolveddivision               ,
                pyresolvedorg                    ,
                pyresolvedorgunit                ,
                pyresolvedtime                   ,
                pyresolvedtimestamp              ,
                pyresolveduserid                 ,
                pyresolveduserworkgroup          ,
                pyrootcause                      ,
                casenumber                       ,
                casereceiveddate                 ,
                documentcategory                 ,
                documenttype                     ,
                memberaccessnumber               ,
                ssn_1                            ,
                caseprocesseddate                ,
                paymentamount                    ,
                paymentdate                      ,
                paymentorderreceived             ,
                receiveddate                     ,
                releasedate                      ,
                courtname_1                      ,
                totalamountowed                  ,
                accessnumber                     ,
                answerbydate                     ,
                primarysaccessnumber             ,
                originatingstate                 ,
                restrictedaccess                 ,
                secondarymembersaccessnumber     ,
                secondarymembersfullname         ,
                primarymemberslast4ssn           ,
                primarymembersfullname           ,
                documentsource                   ,
                addressline1_1                   ,
                phone_1                          ,
                holdtype_1                       ,
                caseassignedto                   ,
                returndate                       ,
                answerbydate2                    ,
                answerbydate3                    ,
                followupdate                     ,
                paymentdate2                     ,
                completeddate                    ,
                recurringpayment                 ,
                documentsmailedtohr              ,
                risk                             ,
                righttogarnishfederalbenefit_1   ,
                noticeofright                    ,
                totalamountonhold                ,
                totalcurrentbalance              ,
                primarymemberaddress             ,
                secondarymemberaddress           ,
                secondarymemberslast4ssn         ,
                feechargeddate                   ,
                feededucted                      ,
                ssn                              ,
                totalchargefee                   ,
                answeredbyspecialist1            ,
                answeredbyspecialist2            ,
                datenfcurespondedtocourtcred_1   ,
                datenfcurespondedtocourtcred_2   ,
                primarymemberstate               ,
                secondarymemberstate             ,
                datemembernotified               ,
                fromdate                         ,
                todate                           ,
                answerduedate                    ,
                computedby                       ,
                paymentprocessedby               ,
                caseassignedempid                ,
                highprioritycase                 ,
                ismember                         ,
                processeddate                    ,
                processedopname                  ,
                autoholdkofaxcase                ,
                casetags                         ,
                autoassigned                     ,
                assignedworkqueuename
        FROM data.Legalops_work_ldm
        WHERE pystatuswork LIKE 'Resolved%'
          AND pxcreatedatetime >= '20250818'
          AND pxcreatedatetime < '20251118'
    ),
    history_table AS
    (
        SELECT
                h.pxhistoryforreference,
                h.pxtimecreated,
                h.pyperformer,
                h.pymessagekey,
                h.pymemo,
                h.pyhistorytype,
                h.pylabel,
                h.pytaskname,
                CASE
                    WHEN h.pyhistorytype IS NULL THEN
                        CASE
                            WHEN h.pymessagekey LIKE '%ItemCreated' THEN 'Created'
                            WHEN h.pymessagekey LIKE '%StatusChanged%' THEN 'Status change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymessagekey LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymemo LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymemo, E'\t', 2)
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'A' THEN
                        CASE
                            WHEN h.pyassignmentclass = 'Assign-Worklist' THEN 'Assigned to operator: ' || h.pytaskname
                            WHEN h.pyassignmentclass = 'Assign-WorkBasket' THEN
                                CASE
                                    WHEN h.pymessagekey LIKE '%deferred@pega.com%' THEN 'Wait'
                                    ELSE 'Assigned to queue '
                                         || split_part(trim(E'\t' FROM h.pymessagekey), E'\t', 2)
                                         || ' : '
                                         || h.pytaskname
                                END
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'F' THEN h.pytaskname
                    WHEN h.pyhistorytype = 'L' THEN split_part(h.pymessagekey, E'\t', 2)
                    WHEN h.pyhistorytype = 'R' THEN 'Transferred'
                    ELSE ''
                END AS activity
        FROM data.Legalops_history_work_ldm h
        JOIN case_table c
          ON c.pzinskey = h.pxhistoryforreference
        WHERE (
                h.pyhistorytype IS NULL
                AND (
                    h.pymessagekey LIKE '%ItemCreated'
                    OR h.pymessagekey LIKE '%StatusChanged%'
                    OR h.pymessagekey LIKE '%ChangeStage%'
                    OR h.pymemo LIKE '%ChangeStage%'
                )
              )
           OR h.pyhistorytype IN ('A','F','L','R')
    )
    SELECT c.pyid,
           c.pzinskey,
           c.pystatuswork,
           c.pxcreatedatetime,
           c.pydescription,
           c.pyeffortactual,
           c.pyeffortestimate,
           c.pyeffortestimatetimestamp,
           c.pyreopencount,
           c.pyreopentimestamp,
           c.pyresolutioncomplexity,
           c.pyresolutioncost,
           c.pyresolveddivision,
           c.pyresolvedorg,
           c.pyresolvedorgunit,
           c.pyresolvedtime,
           c.pyresolvedtimestamp,
           c.pyresolveduserid,
           c.pyresolveduserworkgroup,
           c.pyrootcause,
           c.casenumber,
           c.casereceiveddate,
           c.documentcategory,
           c.documenttype,
           c.memberaccessnumber,
           c.ssn_1,
           c.caseprocesseddate,
           c.paymentamount,
           c.paymentdate,
           c.paymentorderreceived,
           c.receiveddate,
           c.releasedate,
           c.courtname_1,
           c.totalamountowed,
           c.accessnumber,
           c.answerbydate,
           c.primarysaccessnumber,
           c.originatingstate,
           c.restrictedaccess,
           c.secondarymembersaccessnumber,
           c.secondarymembersfullname,
           c.primarymemberslast4ssn,
           c.primarymembersfullname,
           c.documentsource,
           c.addressline1_1,
           c.phone_1,
           c.holdtype_1,
           c.caseassignedto,
           c.returndate,
           c.answerbydate2,
           c.answerbydate3,
           c.followupdate,
           c.paymentdate2,
           c.completeddate,
           c.recurringpayment,
           c.documentsmailedtohr,
           c.risk,
           c.righttogarnishfederalbenefit_1,
           c.noticeofright,
           c.totalamountonhold,
           c.totalcurrentbalance,
           c.primarymemberaddress,
           c.secondarymemberaddress,
           c.secondarymemberslast4ssn,
           c.feechargeddate,
           c.feededucted,
           c.ssn,
           c.totalchargefee,
           c.answeredbyspecialist1,
           c.answeredbyspecialist2,
           c.datenfcurespondedtocourtcred_1,
           c.datenfcurespondedtocourtcred_2,
           c.primarymemberstate,
           c.secondarymemberstate,
           c.datemembernotified,
           c.fromdate,
           c.todate,
           c.answerduedate,
           c.computedby,
           c.paymentprocessedby,
           c.caseassignedempid,
           c.highprioritycase,
           c.ismember,
           c.processeddate,
           c.processedopname,
           c.autoholdkofaxcase,
           c.casetags,
           c.autoassigned,
           c.assignedworkqueuename,
           h.activity,
           h.pymessagekey,
           h.pymemo,
           h.pyhistorytype,
           h.pylabel,
           h.pxtimecreated,
           h.pyperformer
    FROM history_table h
    JOIN case_table c
      ON c.pzinskey = h.pxhistoryforreference
) q
) TO '/dataset/CC-D36701_1.csv' WITH CSV HEADER;





\copy (
SELECT * FROM (
    WITH case_table AS
    (
        SELECT  
                pyid, pzinskey, pystatuswork, pxcreatedatetime, pydescription,
                pyeffortactual, pyeffortestimate, pyeffortestimatetimestamp, pyreopencount,
                pyreopentimestamp, pyresolutioncomplexity, pyresolutioncost, pyresolveddivision,
                pyresolvedorg, pyresolvedorgunit, pyresolvedtime, pyresolvedtimestamp,
                pyresolveduserid, pyresolveduserworkgroup, pyrootcause, casenumber,
                casereceiveddate, documentcategory, documenttype, memberaccessnumber, ssn_1,
                caseprocesseddate, paymentamount, paymentdate, paymentorderreceived,
                receiveddate, releasedate, courtname_1, totalamountowed, accessnumber,
                answerbydate, primarysaccessnumber, originatingstate, restrictedaccess,
                secondarymembersaccessnumber, secondarymembersfullname, primarymemberslast4ssn,
                primarymembersfullname, documentsource, addressline1_1, phone_1, holdtype_1,
                caseassignedto, returndate, answerbydate2, answerbydate3, followupdate,
                paymentdate2, completeddate, recurringpayment, documentsmailedtohr, risk,
                righttogarnishfederalbenefit_1, noticeofright, totalamountonhold,
                totalcurrentbalance, primarymemberaddress, secondarymemberaddress,
                secondarymemberslast4ssn, feechargeddate, feededucted, ssn, totalchargefee,
                answeredbyspecialist1, answeredbyspecialist2, datenfcurespondedtocourtcred_1,
                datenfcurespondedtocourtcred_2, primarymemberstate, secondarymemberstate,
                datemembernotified, fromdate, todate, answerduedate, computedby,
                paymentprocessedby, caseassignedempid, highprioritycase, ismember,
                processeddate, processedopname, autoholdkofaxcase, casetags, autoassigned,
                assignedworkqueuename
        FROM data.Legalops_work_ldm
        WHERE pystatuswork LIKE 'Resolved%'
          AND pxcreatedatetime >= '20251118'
          AND pxcreatedatetime < '20260218'
    ),
    history_table AS
    (
        SELECT
                h.pxhistoryforreference,
                h.pxtimecreated,
                h.pyperformer,
                h.pymessagekey,
                h.pymemo,
                h.pyhistorytype,
                h.pylabel,
                h.pytaskname,
                CASE
                    WHEN h.pyhistorytype IS NULL THEN
                        CASE
                            WHEN h.pymessagekey LIKE '%ItemCreated' THEN 'Created'
                            WHEN h.pymessagekey LIKE '%StatusChanged%' THEN 'Status change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymessagekey LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymemo LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymemo, E'\t', 2)
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'A' THEN
                        CASE
                            WHEN h.pyassignmentclass = 'Assign-Worklist' THEN 'Assigned to operator: ' || h.pytaskname
                            WHEN h.pyassignmentclass = 'Assign-WorkBasket' THEN
                                CASE
                                    WHEN h.pymessagekey LIKE '%deferred@pega.com%' THEN 'Wait'
                                    ELSE 'Assigned to queue '
                                         || split_part(trim(E'\t' FROM h.pymessagekey), E'\t', 2)
                                         || ' : '
                                         || h.pytaskname
                                END
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'F' THEN h.pytaskname
                    WHEN h.pyhistorytype = 'L' THEN split_part(h.pymessagekey, E'\t', 2)
                    WHEN h.pyhistorytype = 'R' THEN 'Transferred'
                    ELSE ''
                END AS activity
        FROM data.Legalops_history_work_ldm h
        JOIN case_table c
          ON c.pzinskey = h.pxhistoryforreference
        WHERE (
                h.pyhistorytype IS NULL
                AND (
                    h.pymessagekey LIKE '%ItemCreated'
                    OR h.pymessagekey LIKE '%StatusChanged%'
                    OR h.pymessagekey LIKE '%ChangeStage%'
                    OR h.pymemo LIKE '%ChangeStage%'
                )
              )
           OR h.pyhistorytype IN ('A','F','L','R')
    )
    SELECT c.*, h.activity, h.pymessagekey, h.pymemo, h.pyhistorytype, h.pylabel, h.pxtimecreated, h.pyperformer
    FROM history_table h
    JOIN case_table c
      ON c.pzinskey = h.pxhistoryforreference
) q
) TO '/dataset/CC-D36701_2.csv' WITH CSV HEADER;


\copy (
SELECT * FROM (
    WITH case_table AS
    (
        SELECT *
        FROM data.Legalops_work_ldm
        WHERE pystatuswork LIKE 'Resolved%'
          AND pxcreatedatetime >= '20260218'
          AND pxcreatedatetime < '20260518'
    ),
    history_table AS
    (
        SELECT
                h.pxhistoryforreference,
                h.pxtimecreated,
                h.pyperformer,
                h.pymessagekey,
                h.pymemo,
                h.pyhistorytype,
                h.pylabel,
                h.pytaskname,
                CASE
                    WHEN h.pyhistorytype IS NULL THEN
                        CASE
                            WHEN h.pymessagekey LIKE '%ItemCreated' THEN 'Created'
                            WHEN h.pymessagekey LIKE '%StatusChanged%' THEN 'Status change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymessagekey LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymemo LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymemo, E'\t', 2)
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'A' THEN
                        CASE
                            WHEN h.pyassignmentclass = 'Assign-Worklist' THEN 'Assigned to operator: ' || h.pytaskname
                            WHEN h.pyassignmentclass = 'Assign-WorkBasket' THEN
                                CASE
                                    WHEN h.pymessagekey LIKE '%deferred@pega.com%' THEN 'Wait'
                                    ELSE 'Assigned to queue '
                                         || split_part(trim(E'\t' FROM h.pymessagekey), E'\t', 2)
                                         || ' : '
                                         || h.pytaskname
                                END
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'F' THEN h.pytaskname
                    WHEN h.pyhistorytype = 'L' THEN split_part(h.pymessagekey, E'\t', 2)
                    WHEN h.pyhistorytype = 'R' THEN 'Transferred'
                    ELSE ''
                END AS activity
        FROM data.Legalops_history_work_ldm h
        JOIN case_table c
          ON c.pzinskey = h.pxhistoryforreference
        WHERE (
                h.pyhistorytype IS NULL
                AND (
                    h.pymessagekey LIKE '%ItemCreated'
                    OR h.pymessagekey LIKE '%StatusChanged%'
                    OR h.pymessagekey LIKE '%ChangeStage%'
                    OR h.pymemo LIKE '%ChangeStage%'
                )
              )
           OR h.pyhistorytype IN ('A','F','L','R')
    )
    SELECT c.*, h.activity, h.pymessagekey, h.pymemo, h.pyhistorytype, h.pylabel, h.pxtimecreated, h.pyperformer
    FROM history_table h
    JOIN case_table c
      ON c.pzinskey = h.pxhistoryforreference
) q
) TO '/dataset/CC-D36701_3.csv' WITH CSV HEADER;




\copy (
SELECT * FROM (
    WITH case_table AS
    (
        SELECT *
        FROM data.Legalops_work_ldm
        WHERE pystatuswork LIKE 'Resolved%'
          AND pxcreatedatetime >= '20260518'
          AND pxcreatedatetime < '20260818'
    ),
    history_table AS
    (
        SELECT
                h.pxhistoryforreference,
                h.pxtimecreated,
                h.pyperformer,
                h.pymessagekey,
                h.pymemo,
                h.pyhistorytype,
                h.pylabel,
                h.pytaskname,
                CASE
                    WHEN h.pyhistorytype IS NULL THEN
                        CASE
                            WHEN h.pymessagekey LIKE '%ItemCreated' THEN 'Created'
                            WHEN h.pymessagekey LIKE '%StatusChanged%' THEN 'Status change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymessagekey LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymessagekey, E'\t', 2)
                            WHEN h.pymemo LIKE '%ChangeStage%' THEN 'Stage change: ' || split_part(h.pymemo, E'\t', 2)
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'A' THEN
                        CASE
                            WHEN h.pyassignmentclass = 'Assign-Worklist' THEN 'Assigned to operator: ' || h.pytaskname
                            WHEN h.pyassignmentclass = 'Assign-WorkBasket' THEN
                                CASE
                                    WHEN h.pymessagekey LIKE '%deferred@pega.com%' THEN 'Wait'
                                    ELSE 'Assigned to queue '
                                         || split_part(trim(E'\t' FROM h.pymessagekey), E'\t', 2)
                                         || ' : '
                                         || h.pytaskname
                                END
                            ELSE ''
                        END
                    WHEN h.pyhistorytype = 'F' THEN h.pytaskname
                    WHEN h.pyhistorytype = 'L' THEN split_part(h.pymessagekey, E'\t', 2)
                    WHEN h.pyhistorytype = 'R' THEN 'Transferred'
                    ELSE ''
                END AS activity
        FROM data.Legalops_history_work_ldm h
        JOIN case_table c
          ON c.pzinskey = h.pxhistoryforreference
        WHERE (
                h.pyhistorytype IS NULL
                AND (
                    h.pymessagekey LIKE '%ItemCreated'
                    OR h.pymessagekey LIKE '%StatusChanged%'
                    OR h.pymessagekey LIKE '%ChangeStage%'
                    OR h.pymemo LIKE '%ChangeStage%'
                )
              )
           OR h.pyhistorytype IN ('A','F','L','R')
    )
    SELECT c.*, h.activity, h.pymessagekey, h.pymemo, h.pyhistorytype, h.pylabel, h.pxtimecreated, h.pyperformer
    FROM history_table h
    JOIN case_table c
      ON c.pzinskey = h.pxhistoryforreference
) q
) TO '/dataset/CC-D36701_4.csv' WITH CSV HEADER;