\timing
set temp_file_limit=-1;
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



 DO $$
DECLARE
batch_size INTEGER := 50000;
total_deleted INTEGER := 0;
rows_deleted INTEGER;
BEGIN
LOOP
DELETE FROM customerdata.pr_cbagrp_fch_data_alert_77057 WHERE pyguid IN ( SELECT pyguid FROM customerdata.pr_cbagrp_fch_data_alert_77057 C WHERE C.FCPID IN ( SELECT A.FCPID FROM customerdata.pr_cbagrp_fch_data_alert_77057 A WHERE A.pxCreateDateTime < TIMESTAMP '2026-03-01 00:00:00' ) LIMIT batch_size );
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