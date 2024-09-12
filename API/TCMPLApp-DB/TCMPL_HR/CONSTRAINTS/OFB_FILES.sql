--------------------------------------------------------
--  Constraints for Table OFB_FILES
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_FILES" MODIFY ("KEY_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_FILES" ADD CONSTRAINT "OFB_FILES_PK" PRIMARY KEY ("KEY_ID")
  USING INDEX  ENABLE;
