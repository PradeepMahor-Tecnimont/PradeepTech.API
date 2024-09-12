--------------------------------------------------------
--  DDL for Trigger TRIG_USERIDS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIG_USERIDS_01" BEFORE INSERT OR UPDATE OF USERID ON USERIDS 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.userid := upper(:new.userid);
  :new.domain := REPLACE(upper(:new.domain),'.COMP','');
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIG_USERIDS_01" ENABLE;
