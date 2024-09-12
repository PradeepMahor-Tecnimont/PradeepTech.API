--------------------------------------------------------
--  DDL for Table DIST_LAPTOP_ALREADY_ISSUED_LOG
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."DIST_LAPTOP_ALREADY_ISSUED_LOG" 
   (	"EMPNO" CHAR(5), 
	"LAPTOP_AMS_ID" VARCHAR2(30), 
	"PERMANENT_ISSUED" VARCHAR2(2), 
	"MODIFIED_ON" DATE, 
	"IS_ISSUED" NUMBER(1,0)
   ) ;
