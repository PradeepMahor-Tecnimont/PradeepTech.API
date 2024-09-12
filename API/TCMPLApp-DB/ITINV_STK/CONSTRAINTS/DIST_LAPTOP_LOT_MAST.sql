--------------------------------------------------------
--  Constraints for Table DIST_LAPTOP_LOT_MAST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_LOT_MAST" MODIFY ("KEY_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_LOT_MAST" ADD CONSTRAINT "DIST_LAPTOP_LOT_MAST_PK" PRIMARY KEY ("KEY_ID")
  USING INDEX  ENABLE;
