--------------------------------------------------------
--  DDL for Trigger SS_9794_ROLE_MAST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_9794_ROLE_MAST" 
BEFORE INSERT OR UPDATE OF ROLE_NAME ON SS_9794_ROLE_MASTER 
REFERENCING OLD AS OLD NEW AS NEW 
for each row
BEGIN
  :new.role_name := upper(:new.role_name);
END;

/
ALTER TRIGGER "SELFSERVICE"."SS_9794_ROLE_MAST" ENABLE;
