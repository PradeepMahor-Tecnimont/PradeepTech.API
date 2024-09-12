--------------------------------------------------------
--  Ref Constraints for Table STK_USER_RIGHTS
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."STK_USER_RIGHTS" ADD CONSTRAINT "STK_USER_RIGHTS_FK1" FOREIGN KEY ("EMP_ROLE")
	  REFERENCES "ITINV_STK"."STK_PROFILE_MASTER" ("PROFILE_NAME") ENABLE;
