--------------------------------------------------------
--  DDL for Table EMP_SCAN_FILE
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_SCAN_FILE" 
   (	"EMPNO" CHAR(5), 
	"FILE_TYPE" CHAR(2), 
	"FILE_NAME" VARCHAR2(200), 
	"MODIFIED_ON" DATE, 
	"REF_NUMBER" VARCHAR2(50)
   ) ;

   COMMENT ON COLUMN "COMMONMASTERS"."EMP_SCAN_FILE"."REF_NUMBER" IS 'AADHAAR No / Passport No';
