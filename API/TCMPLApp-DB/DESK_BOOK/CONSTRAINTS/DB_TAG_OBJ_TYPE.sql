--------------------------------------------------------
--  Constraints for Table DB_TAG_OBJ_TYPE
--------------------------------------------------------

  ALTER TABLE "DESK_BOOK"."DB_TAG_OBJ_TYPE" MODIFY ("OBJ_TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "DESK_BOOK"."DB_TAG_OBJ_TYPE" MODIFY ("OBJ_TYPE_NAME" NOT NULL ENABLE);
  ALTER TABLE "DESK_BOOK"."DB_TAG_OBJ_TYPE" ADD CONSTRAINT "DB_TAG_OBJ_TYPE_UK1" UNIQUE ("OBJ_TYPE_ID")
  USING INDEX  ENABLE;
