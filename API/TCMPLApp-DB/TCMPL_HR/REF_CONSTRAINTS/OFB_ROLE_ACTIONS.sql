--------------------------------------------------------
--  Ref Constraints for Table OFB_ROLE_ACTIONS
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_ROLE_ACTIONS" ADD CONSTRAINT "OFB_ROLE_ACTIONS_FK1" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "TCMPL_HR"."OFB_ROLES" ("ROLE_ID") ENABLE;
