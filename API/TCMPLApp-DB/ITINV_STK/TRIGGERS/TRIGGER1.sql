--------------------------------------------------------
--  DDL for Trigger TRIGGER1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIGGER1" 
before update of country_code,empno,emp_extn,key_id,projno,req_date,req_tel_no on op_call_log 
referencing old as old new as new
for each row
begin
  :new.modified_on := sysdate;
end;
/
ALTER TRIGGER "ITINV_STK"."TRIGGER1" ENABLE;
