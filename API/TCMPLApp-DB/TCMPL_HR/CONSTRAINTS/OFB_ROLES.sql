--------------------------------------------------------
--  Constraints for Table OFB_ROLES
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_ROLES" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_ROLES" MODIFY ("ROLE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_ROLES" MODIFY ("ROLE_DESC" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_ROLES" ADD CONSTRAINT "OFB_ROLES_PK" PRIMARY KEY ("ROLE_ID")
  USING INDEX  ENABLE;
