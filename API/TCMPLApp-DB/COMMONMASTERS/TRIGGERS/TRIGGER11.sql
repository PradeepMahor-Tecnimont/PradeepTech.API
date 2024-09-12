--------------------------------------------------------
--  DDL for Trigger TRIGGER11
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER11" 
before insert or update of modified_on on emp_adhaar 
referencing old as old new as new 
for each row
begin
  :new.modified_on := sysdate;
end;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER11" ENABLE;
