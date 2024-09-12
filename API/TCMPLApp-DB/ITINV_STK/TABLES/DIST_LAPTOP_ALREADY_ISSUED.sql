--------------------------------------------------------
--  DDL for Table DIST_LAPTOP_ALREADY_ISSUED
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."DIST_LAPTOP_ALREADY_ISSUED" 
   (	"EMPNO" CHAR(5), 
	"LAPTOP_AMS_ID" VARCHAR2(30), 
	"PERMANENT_ISSUED" VARCHAR2(2), 
	"MODIFIED_ON" DATE, 
	"LETTER_REF_NO" VARCHAR2(20)
   ) ;
  GRANT SELECT ON "ITINV_STK"."DIST_LAPTOP_ALREADY_ISSUED" TO "DMS";
