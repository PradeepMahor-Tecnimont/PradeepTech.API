--------------------------------------------------------
--  DDL for Trigger TRIG_CONFIG_SCHEMA_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_CONFIG_SCHEMA_01" Before
    Insert Or Update Of schema_name On config_schema
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.schema_name := Upper(Trim(:new.schema_name));
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_CONFIG_SCHEMA_01" ENABLE;
