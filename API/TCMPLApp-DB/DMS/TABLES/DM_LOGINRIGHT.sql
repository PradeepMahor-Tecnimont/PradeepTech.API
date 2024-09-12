--------------------------------------------------------
--  DDL for Table DM_LOGINRIGHT
--------------------------------------------------------

  CREATE TABLE "DM_LOGINRIGHT" 
   (	"TRANS_ID" VARCHAR2(20), 
	"TRANS_DATE" DATE, 
	"FROM_DESK" VARCHAR2(7), 
	"FROM_MACHINE" VARCHAR2(20), 
	"TO_DESK" VARCHAR2(7), 
	"TO_MACHINE" VARCHAR2(20), 
	"EMPNO" CHAR(5), 
	"FLAG_APPRD" NUMBER(1,0), 
	"LOG_FILE" VARCHAR2(200)
   ) ;
