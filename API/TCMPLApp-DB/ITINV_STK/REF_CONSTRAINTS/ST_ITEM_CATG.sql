--------------------------------------------------------
--  Ref Constraints for Table ST_ITEM_CATG
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."ST_ITEM_CATG" ADD CONSTRAINT "ST_ITEM_CATG_FK1" FOREIGN KEY ("REF_TYPE_ID")
	  REFERENCES "ITINV_STK"."ST_REF_TYPE_MASTER" ("REF_TYPE_ID") ENABLE;
