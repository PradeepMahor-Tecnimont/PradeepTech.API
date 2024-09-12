--------------------------------------------------------
--  DDL for Trigger STK_USER_RIGHTS_T1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."STK_USER_RIGHTS_T1" 
BEFORE
insert on "STK_USER_RIGHTS"
for each row
begin
:New.Key_ID := dbms_random.string('X',8);
end;

/
ALTER TRIGGER "ITINV_STK"."STK_USER_RIGHTS_T1" ENABLE;
