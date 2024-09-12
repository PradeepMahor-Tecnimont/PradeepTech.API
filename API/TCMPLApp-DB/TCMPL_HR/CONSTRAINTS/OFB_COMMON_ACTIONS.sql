--------------------------------------------------------
--  Constraints for Table OFB_COMMON_ACTIONS
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_COMMON_ACTIONS" MODIFY ("COMMON_ACTION_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_COMMON_ACTIONS" ADD CONSTRAINT "OFB_COMMON_ACTIONS_PK" PRIMARY KEY ("COMMON_ACTION_ID")
  USING INDEX  ENABLE;
