--------------------------------------------------------
--  Constraints for Table STK_PROFILE_MASTER
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."STK_PROFILE_MASTER" MODIFY ("PROFILE_NAME" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."STK_PROFILE_MASTER" ADD CONSTRAINT "STK_PROFILE_MASTER_PK" PRIMARY KEY ("PROFILE_NAME")
  USING INDEX  ENABLE;
