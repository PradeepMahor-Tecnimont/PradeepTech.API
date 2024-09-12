--------------------------------------------------------
--  Constraints for Table DIST_LAPTOP_STATUS
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_STATUS" MODIFY ("AMS_ASSET_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_STATUS" ADD CONSTRAINT "DIST_LAPTOP_STATUS_PK" PRIMARY KEY ("AMS_ASSET_ID")
  USING INDEX  ENABLE;
