--------------------------------------------------------
--  DDL for Trigger TRIG_SEC_MODULE_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_01" Before
    Insert Or Update Of module_name, module_id On "SEC_MODULES"
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.module_name        := Upper(Trim(:new.module_name));
    :new.module_id          := Upper(Trim(:new.module_id));
    :new.module_is_active   := Trim(Upper(:new.module_is_active));
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_01" ENABLE;
