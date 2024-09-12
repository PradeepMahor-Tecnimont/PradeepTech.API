--------------------------------------------------------
--  Ref Constraints for Table ST_ITEM_REQUESTS
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."ST_ITEM_REQUESTS" ADD CONSTRAINT "ST_ITEM_REQUESTS_FK2" FOREIGN KEY ("ITEM_CODE")
	  REFERENCES "ITINV_STK"."ST_ITEM_MAST" ("ITEM_CODE") ENABLE;
