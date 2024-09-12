--------------------------------------------------------
--  DDL for Table DM_SPECIAL_SHIFTING
--------------------------------------------------------

  CREATE TABLE "DM_SPECIAL_SHIFTING" 
   (	"EMPNO" CHAR(5), 
	"LOGINID" VARCHAR2(20), 
	"COMPNAME" VARCHAR2(20), 
	"FROM_DATE" DATE, 
	"TO_DATE" DATE, 
	"REASON" VARCHAR2(50), 
	"FLAG_APPLIED" NUMBER(1,0), 
	"FLAG_ROLLBACK" NUMBER(1,0), 
	"TRANS_DATE" DATE
   ) ;
