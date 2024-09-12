--------------------------------------------------------
--  Constraints for Table EMP_SCAN_FILE_TYPES
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_SCAN_FILE_TYPES" ADD CONSTRAINT "EMP_SCAN_FILE_TYPES_PK" PRIMARY KEY ("FILE_TYPE")
  USING INDEX  ENABLE;
  ALTER TABLE "COMMONMASTERS"."EMP_SCAN_FILE_TYPES" MODIFY ("FILE_TYPE" NOT NULL ENABLE);
