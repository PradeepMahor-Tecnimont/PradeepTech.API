--------------------------------------------------------
--  Constraints for Table OFB_USER_ROLES
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_USER_ROLES" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_USER_ROLES" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_USER_ROLES" ADD CONSTRAINT "OFB_USER_ROLES_PK" PRIMARY KEY ("EMPNO", "ROLE_ID") DISABLE;
