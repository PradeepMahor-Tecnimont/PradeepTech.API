--------------------------------------------------------
--  DDL for Trigger TRIGGER7
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIGGER7" 
BEFORE INSERT ON SS_HOLIDAY_ATTENDANCE 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.app_date := sysdate;
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIGGER7" ENABLE;
