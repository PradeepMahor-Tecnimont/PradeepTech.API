--------------------------------------------------------
--  DDL for Trigger TRIGGER10
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER10" 
BEFORE UPDATE OF EMPNO,MEMBER,DOB,RELATION,OCCUPATION,REMARKS ON EMP_FAMILY 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
    :new.modified_on := sysdate;
Exception
  when others then
    null;
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER10" ENABLE;
