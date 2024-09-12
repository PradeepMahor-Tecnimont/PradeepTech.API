--------------------------------------------------------
--  Constraints for Table DIST_HEADSET_ISSUED
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_HEADSET_ISSUED" MODIFY ("MFG_SR_NO" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_HEADSET_ISSUED" ADD CONSTRAINT "DIST_HEADSET_ISSUED_PK" PRIMARY KEY ("MFG_SR_NO")
  USING INDEX  ENABLE;
