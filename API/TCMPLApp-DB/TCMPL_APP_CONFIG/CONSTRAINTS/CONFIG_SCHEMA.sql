--------------------------------------------------------
--  Constraints for Table CONFIG_SCHEMA
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."CONFIG_SCHEMA" ADD CONSTRAINT "CONFIG_SCHEMA_PK" PRIMARY KEY ("SCHEMA_NAME")
  USING INDEX  ENABLE;
  ALTER TABLE "TCMPL_APP_CONFIG"."CONFIG_SCHEMA" MODIFY ("SCHEMA_NAME" NOT NULL ENABLE);
