--------------------------------------------------------
--  Constraints for Table DIST_LAPTOP_LOT_DETAILS
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_LOT_DETAILS" MODIFY ("SAP_ASSET_CODE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_LOT_DETAILS" MODIFY ("KEY_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_LOT_DETAILS" ADD CONSTRAINT "DIST_LAPTOP_LOT_DETAILS_PK" PRIMARY KEY ("KEY_ID", "SAP_ASSET_CODE")
  USING INDEX  ENABLE;
