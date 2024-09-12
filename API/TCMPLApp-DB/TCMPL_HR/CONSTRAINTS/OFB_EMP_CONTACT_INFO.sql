--------------------------------------------------------
--  Constraints for Table OFB_EMP_CONTACT_INFO
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_EMP_CONTACT_INFO" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_EMP_CONTACT_INFO" ADD CONSTRAINT "OFB_EMP_CONTACT_INFO_PK" PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
