--------------------------------------------------------
--  Ref Constraints for Table EMP_SCAN_FILE
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_SCAN_FILE" ADD CONSTRAINT "EMP_SCAN_FILE_FK1" FOREIGN KEY ("FILE_TYPE")
	  REFERENCES "COMMONMASTERS"."EMP_SCAN_FILE_TYPES" ("FILE_TYPE") ENABLE;
