history
===========

fields @timestamp, @message
| filter @message like /automatic vacuum/
  and @message like /"pega.customerdata.pr_unilever_fw_plc_data__81f08"/
| sort @timestamp desc
| limit 200

========================
fields @timestamp, @message
| filter @message like /automatic vacuum/
  and @message like /"pega.customerdata.pr_unilever_fw_plc_data__81f08"/
| stats count() as total_autovacuum_runs by bin(1d)
| sort bin(1d) desc


this will give all select respective to table
====================================
fields @timestamp, @message
| filter @message like /SELECT/ and @message like /pr_unilever_fw_plc_data__81f08/
| sort @timestamp desc
| limit 20


fields @timestamp, @message
| filter @message like /pr_unilever_fw_plc_data__81f08/
| filter @message like /SELECT/
| stats count() as total_select_queries by bin(1d)
| sort @timestamp desc
| limit 10


→ sh copy file from to and from fullautomated.sh