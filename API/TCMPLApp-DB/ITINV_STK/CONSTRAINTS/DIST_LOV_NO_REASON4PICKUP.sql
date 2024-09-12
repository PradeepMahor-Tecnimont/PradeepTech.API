--------------------------------------------------------
--  Constraints for Table DIST_LOV_NO_REASON4PICKUP
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_LOV_NO_REASON4PICKUP" MODIFY ("REASON_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_LOV_NO_REASON4PICKUP" ADD CONSTRAINT "DIST_LOV_NO_REASON4PICKUP_PK" PRIMARY KEY ("REASON_ID")
  USING INDEX  ENABLE;
