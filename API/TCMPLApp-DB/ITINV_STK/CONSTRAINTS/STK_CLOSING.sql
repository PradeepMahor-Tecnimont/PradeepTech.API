--------------------------------------------------------
--  Constraints for Table STK_CLOSING
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."STK_CLOSING" MODIFY ("SUBITEM" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."STK_CLOSING" MODIFY ("ITEM" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."STK_CLOSING" MODIFY ("ON_DATE" NOT NULL ENABLE);
