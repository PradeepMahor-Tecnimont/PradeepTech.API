--------------------------------------------------------
--  Constraints for Table DIST_ROLES_2_USER
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_ROLES_2_USER" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_ROLES_2_USER" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_ROLES_2_USER" ADD CONSTRAINT "DIST_ROLES_2_USER_PK" PRIMARY KEY ("ROLE_ID", "EMPNO")
  USING INDEX  ENABLE;
