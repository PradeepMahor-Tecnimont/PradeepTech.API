--------------------------------------------------------
--  DDL for Trigger TRIGGER1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER1" 
BEFORE INSERT OR UPDATE OF NOM_NAME,NOM_ADD1,RELATION ON EMP_EPS_4_ALL 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.nom_name := upper(:new.nom_name);
  :new.nom_add1 := upper(:new.nom_add1);
  :new.RELATION := upper(:new.RELATION);
  :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER1" ENABLE;
