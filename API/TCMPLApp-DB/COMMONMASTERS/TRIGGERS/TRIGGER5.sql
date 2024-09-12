--------------------------------------------------------
--  DDL for Trigger TRIGGER5
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER5" BEFORE
  INSERT OR
  UPDATE OF 
    NOM_NAME,
    NOM_ADD1,
    RELATION
    ON EMP_sup_annuation REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW BEGIN 
  :new.nom_name := upper(:new.nom_name);
  :new.nom_add1 := upper(:new.nom_add1);
  :new.relation := upper(:new.relation);
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER5" ENABLE;
