--------------------------------------------------------
--  Ref Constraints for Table SS_9794_EMP_ROLES
--------------------------------------------------------

  ALTER TABLE "SS_9794_EMP_ROLES" ADD CONSTRAINT "SS_9794_EMP_ROLES_FK1" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "SS_9794_ROLE_MASTER" ("ROLE_ID") ENABLE;
