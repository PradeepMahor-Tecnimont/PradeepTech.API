--------------------------------------------------------
--  DDL for Trigger TRIG2_BB_EMP_PC_LOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG2_BB_EMP_PC_LOG" 
before update of empno,pcname,delete_flag on bb_emp_pc_log 
referencing old as old new as new 
for each row
begin
  :new.modified_on := sysdate;
end;
/
ALTER TRIGGER "ITINV_STK"."TRIG2_BB_EMP_PC_LOG" ENABLE;
