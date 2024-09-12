--------------------------------------------------------
--  DDL for Table EMP_FAMILY_LOG
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_FAMILY_LOG" 
   (	"EMPNO" CHAR(5), 
	"MEMBER" VARCHAR2(60), 
	"DOB" DATE, 
	"RELATION" NUMBER(2,0), 
	"OCCUPATION" NUMBER(2,0), 
	"REMARKS" VARCHAR2(200), 
	"CHG_DATE" DATE, 
	"CHG_TYPE" VARCHAR2(20), 
	"KEY_ID" VARCHAR2(8)
   ) ;

   COMMENT ON COLUMN "COMMONMASTERS"."EMP_FAMILY_LOG"."CHG_TYPE" IS 'INSERT, UPDATE, DELETE';
