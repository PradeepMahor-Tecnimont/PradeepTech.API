--------------------------------------------------------
--  DDL for Trigger OP_CALL_LOG_TRIG_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."OP_CALL_LOG_TRIG_01" 
   before insert on "ITINV_STK"."OP_CALL_LOG" 
   for each row 
begin  
   if inserting then 
      if :NEW."KEY_ID" is null then 
         select OP_CALL_LOG_PK_SEQ.nextval into :NEW."KEY_ID" from dual; 
      end if;
      :new.modified_on := sysdate;
   end if; 
end;
/
ALTER TRIGGER "ITINV_STK"."OP_CALL_LOG_TRIG_01" ENABLE;
