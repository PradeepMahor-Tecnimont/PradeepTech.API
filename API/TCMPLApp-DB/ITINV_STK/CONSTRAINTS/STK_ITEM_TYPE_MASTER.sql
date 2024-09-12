--------------------------------------------------------
--  Constraints for Table STK_ITEM_TYPE_MASTER
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."STK_ITEM_TYPE_MASTER" MODIFY ("KEY_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."STK_ITEM_TYPE_MASTER" ADD CONSTRAINT "STK_ITEM_TYPE_MASTER_PK" PRIMARY KEY ("KEY_ID")
  USING INDEX  ENABLE;
