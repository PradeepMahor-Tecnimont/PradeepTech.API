--------------------------------------------------------
--  DDL for Trigger TRIGGER3
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER3" 
BEFORE INSERT OR UPDATE OF NOM_NAME,NOM_ADD1,RELATION,NOM_MINOR_GUARD_NAME,NOM_MINOR_GUARD_ADD1,nom_minor_guard_relation ON EMP_EPF 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.nom_name := upper(:new.nom_name);
  :new.nom_add1 := upper(:new.nom_add1);
  :new.relation := upper(:new.relation);
  :new.nom_minor_guard_name := upper(:new.nom_minor_guard_name );
  :new.nom_minor_guard_add1 := upper(:new.nom_minor_guard_add1);
  :new.nom_minor_guard_relation := upper(:new.nom_minor_guard_relation);
  :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER3" ENABLE;
