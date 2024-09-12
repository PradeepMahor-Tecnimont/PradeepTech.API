--------------------------------------------------------
--  DDL for Trigger TRIG_SEC_MODULE_ROLES_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_ROLES_01" Before
    Insert Or Update Of module_role_key_id , module_id, role_id On sec_module_roles
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.module_role_key_id := :new.module_id || :new.role_id;
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_ROLES_01" ENABLE;
