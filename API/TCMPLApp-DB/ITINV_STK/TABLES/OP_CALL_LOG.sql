--------------------------------------------------------
--  DDL for Table OP_CALL_LOG
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."OP_CALL_LOG" 
   (	"KEY_ID" NUMBER, 
	"EMPNO" CHAR(5), 
	"PROJNO" CHAR(5), 
	"COUNTRY_CODE" VARCHAR2(100), 
	"REQ_TEL_NO" VARCHAR2(20), 
	"EMP_EXTN" VARCHAR2(20), 
	"REQ_DATE" DATE, 
	"MODIFIED_ON" DATE, 
	"ENTRY_BY" VARCHAR2(5)
   ) ;
