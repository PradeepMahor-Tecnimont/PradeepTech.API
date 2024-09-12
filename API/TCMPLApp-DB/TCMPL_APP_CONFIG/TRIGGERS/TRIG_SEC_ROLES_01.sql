--------------------------------------------------------
--  DDL for Trigger TRIG_SEC_ROLES_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_ROLES_01" Before
    Insert Or Update On sec_roles
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.role_id          := Trim(Upper(:new.role_id));
    :new.role_name        := Trim(Upper(:new.role_name));
    :new.role_is_active   := Trim(Upper(:new.role_is_active));
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_ROLES_01" ENABLE;
