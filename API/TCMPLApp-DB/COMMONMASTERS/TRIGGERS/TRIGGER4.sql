--------------------------------------------------------
--  DDL for Trigger TRIGGER4
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER4" BEFORE
  INSERT OR
  UPDATE OF 
    NOM_NAME,
    NOM_ADD1,
    RELATION
    ON EMP_gratuity REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW BEGIN 
  :new.nom_name := upper(:new.nom_name);
  :new.nom_add1 := upper(:new.nom_add1);
  :new.relation := upper(:new.relation);
  :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER4" ENABLE;
