--------------------------------------------------------
--  DDL for Procedure ROLLBACK_WORKFILE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."ROLLBACK_WORKFILE" as
begin
delete from inv_workfile1;
delete from inv_workfile2;
update inv_invoice_master set rollback_current = 0;
update inv_loa_details set delta_current = 0,delta_current_amount = 0,rollback_current = 0,rollback_current_amount = 0;
update inv_invoice_nos set last_inv = prev_last_inv, last_delta_inv = prev_last_delta_inv;
commit;
end

;

/
