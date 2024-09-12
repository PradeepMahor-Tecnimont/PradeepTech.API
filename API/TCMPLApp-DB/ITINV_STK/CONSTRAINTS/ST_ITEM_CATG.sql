--------------------------------------------------------
--  Constraints for Table ST_ITEM_CATG
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."ST_ITEM_CATG" MODIFY ("CATG_DESC" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ST_ITEM_CATG" MODIFY ("CATG_CODE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ST_ITEM_CATG" ADD CONSTRAINT "ST_ITEM_CATG_PK" PRIMARY KEY ("CATG_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "ITINV_STK"."ST_ITEM_CATG" ADD CONSTRAINT "ST_ITEM_CATG_CHK2" CHECK (nvl(trim(catg_desc),' ') <> ' ') ENABLE;
  ALTER TABLE "ITINV_STK"."ST_ITEM_CATG" ADD CONSTRAINT "ST_ITEM_CATG_CHK1" CHECK (nvl(trim(catg_code),' ') <> ' ' and catg_code = Upper(catg_code)) ENABLE;
