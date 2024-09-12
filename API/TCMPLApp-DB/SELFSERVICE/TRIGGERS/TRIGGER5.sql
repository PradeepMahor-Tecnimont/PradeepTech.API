--------------------------------------------------------
--  DDL for Trigger TRIGGER5
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIGGER5" 
BEFORE INSERT OR UPDATE OF USERID ON SELFSERVICE.USERIDS 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.userid := upper(:new.userid);
  :new.domain := upper(:new.domain);
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIGGER5" ENABLE;
