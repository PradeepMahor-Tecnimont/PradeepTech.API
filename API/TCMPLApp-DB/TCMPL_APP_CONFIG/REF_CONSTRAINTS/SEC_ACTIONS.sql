--------------------------------------------------------
--  Ref Constraints for Table SEC_ACTIONS
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" ADD CONSTRAINT "SEC_ACTIONS_FK1" FOREIGN KEY ("MODULE_ID")
	  REFERENCES "TCMPL_APP_CONFIG"."SEC_MODULES" ("MODULE_ID") ENABLE;
