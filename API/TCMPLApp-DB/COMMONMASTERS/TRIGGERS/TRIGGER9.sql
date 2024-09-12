--------------------------------------------------------
--  DDL for Trigger TRIGGER9
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER9" 
BEFORE INSERT OR UPDATE OF EMPNO,NOM_NAME,NOM_ADD1,RELATION,NOM_DOB,SHARE_PCNT ON EMP_SUP_ANNUATION 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER9" ENABLE;
