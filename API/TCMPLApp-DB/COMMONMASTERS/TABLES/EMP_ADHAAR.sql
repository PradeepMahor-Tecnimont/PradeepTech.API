--------------------------------------------------------
--  DDL for Table EMP_ADHAAR
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_ADHAAR" 
   (	"EMPNO" CHAR(5), 
	"ADHAAR_NO" VARCHAR2(12), 
	"ADHAAR_NAME" VARCHAR2(100), 
	"MODIFIED_ON" DATE
   ) ;
  GRANT SELECT ON "COMMONMASTERS"."EMP_ADHAAR" TO "TIMECURR";
