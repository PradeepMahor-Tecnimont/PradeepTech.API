--------------------------------------------------------
--  Ref Constraints for Table ST_ITEM_MAST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."ST_ITEM_MAST" ADD CONSTRAINT "ST_ITEM_MAST_FK1" FOREIGN KEY ("ITEM_CATG_ID")
	  REFERENCES "ITINV_STK"."ST_ITEM_CATG" ("CATG_ID") ENABLE;
