--------------------------------------------------------
--  Constraints for Table OFB_COMMON_ACTIONS_MAPPING
--------------------------------------------------------

  ALTER TABLE "TCMPL_HR"."OFB_COMMON_ACTIONS_MAPPING" MODIFY ("COMMON_ACTION_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_HR"."OFB_COMMON_ACTIONS_MAPPING" ADD CONSTRAINT "OFB_COMMON_ACTIONS_MAPPIN_UK1" UNIQUE ("COMMON_ACTION_ID", "ROLE_ID", "ACTION_ID")
  USING INDEX  ENABLE;
