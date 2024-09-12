--------------------------------------------------------
--  DDL for Trigger TL_PHONE_EXTENSIONS_T2
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TL_PHONE_EXTENSIONS_T2" 
BEFORE
insert on "TL_PHONE_EXTENSIONS"
for each row
begin
:New.Key_id := dbms_random.string('X',5);
end;

/
ALTER TRIGGER "ITINV_STK"."TL_PHONE_EXTENSIONS_T2" ENABLE;
