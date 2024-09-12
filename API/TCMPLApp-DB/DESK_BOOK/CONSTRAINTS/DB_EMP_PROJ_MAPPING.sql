--------------------------------------------------------
--  Constraints for Table DB_EMP_PROJ_MAPPING
--------------------------------------------------------

  ALTER TABLE "DESK_BOOK"."DB_EMP_PROJ_MAPPING" MODIFY ("KEY_ID" NOT NULL ENABLE);
  ALTER TABLE "DESK_BOOK"."DB_EMP_PROJ_MAPPING" ADD CONSTRAINT "DB_EMP_PROJ_MAPPING_PK" PRIMARY KEY ("KEY_ID")
  USING INDEX "DESK_BOOK"."DB_EMP_PROJ_MAPPING_PK"  ENABLE;
