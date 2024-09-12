--------------------------------------------------------
--  Ref Constraints for Table DIST_ROLES_2_USER
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_ROLES_2_USER" ADD CONSTRAINT "DIST_ROLES_2_USER_FK1" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "ITINV_STK"."DIST_ROLE_MAST" ("ROLE_ID") ENABLE;
