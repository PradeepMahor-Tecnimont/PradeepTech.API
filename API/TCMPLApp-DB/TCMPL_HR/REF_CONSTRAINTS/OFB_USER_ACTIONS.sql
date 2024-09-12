--------------------------------------------------------
--  Ref Constraints for Table OFB_USER_ACTIONS
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_USER_ACTIONS" ADD CONSTRAINT "OFB_USER_ACTIONS_FK1" FOREIGN KEY ("ACTION_ID")
	  REFERENCES "TCMPL_HR"."OFB_ROLE_ACTIONS" ("ACTION_ID") ENABLE;
