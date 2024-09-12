--------------------------------------------------------
--  DDL for Trigger TRIGGER2
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER2" 
BEFORE INSERT OR UPDATE OF NOM_NAME,NOM_ADD1,RELATION ON EMP_EPS_4_MARRIED 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.nom_name := upper(:new.nom_name);
  :new.nom_add1 := upper(:new.nom_add1);
  :new.relation := upper(:new.relation);
  :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER2" ENABLE;
