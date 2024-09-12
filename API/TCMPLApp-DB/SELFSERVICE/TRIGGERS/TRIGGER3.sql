--------------------------------------------------------
--  DDL for Trigger TRIGGER3
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIGGER3" 
BEFORE INSERT OR UPDATE OF EMPNO,START_DATE ON SS_SITE_ALLOWANCE_TRANS 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIGGER3" ENABLE;
