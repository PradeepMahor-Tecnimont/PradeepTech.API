--------------------------------------------------------
--  DDL for Trigger TRIG_ROLES_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_HR"."TRIG_ROLES_01" Before
    Insert Or Update Of role_name, role_id On ofb_roles
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.role_name   := Upper(Trim(:new.role_name));
    :new.role_id     := Upper(Trim(:new.role_id));
End;

/
ALTER TRIGGER "TCMPL_HR"."TRIG_ROLES_01" ENABLE;
