--------------------------------------------------------
--  Constraints for Table ST_ITEM_MAST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."ST_ITEM_MAST" MODIFY ("ITEM_CATG_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ST_ITEM_MAST" ADD CONSTRAINT "ST_ITEM_MAST_UK1" UNIQUE ("ITEM_CODE")
  USING INDEX  ENABLE;
  ALTER TABLE "ITINV_STK"."ST_ITEM_MAST" ADD CONSTRAINT "ST_ITEM_MAST_PK" PRIMARY KEY ("ITEM_ID")
  USING INDEX  ENABLE;
