--------------------------------------------------------
--  DDL for Trigger TRIG1_BB_EMP_PC_LOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG1_BB_EMP_PC_LOG" 
before insert on bb_emp_pc_log 
referencing old as old new as new 
for each row
begin
  :new.key_id := dbms_random.string('X',5);
  :new.DELETE_flag := 0;
  :new.modified_on := sysdate;
end;
/
ALTER TRIGGER "ITINV_STK"."TRIG1_BB_EMP_PC_LOG" ENABLE;
