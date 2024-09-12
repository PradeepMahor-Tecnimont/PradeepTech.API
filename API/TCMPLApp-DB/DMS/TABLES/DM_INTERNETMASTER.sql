--------------------------------------------------------
--  DDL for Table DM_INTERNETMASTER
--------------------------------------------------------

  CREATE TABLE "DM_INTERNETMASTER" 
   (	"EMPNO" CHAR(5), 
	"PC_NAME" VARCHAR2(25), 
	"PC_IP" VARCHAR2(20), 
	"INTERNET_ID" VARCHAR2(50), 
	"GRANT_DATE" DATE, 
	"ACCESS_STATUS" NUMBER(1,0) DEFAULT 0, 
	"REVOKE_DATE" DATE
   ) ;

   COMMENT ON COLUMN "DM_INTERNETMASTER"."ACCESS_STATUS" IS '"1" is Granted, "-1" is Revoked';
