--------------------------------------------------------
--  DDL for Table DM_LAPTOP
--------------------------------------------------------

  CREATE TABLE "DM_LAPTOP" 
   (	"LP_REQNO" VARCHAR2(20), 
	"LP_REQDATE" DATE, 
	"EMPNO" CHAR(5), 
	"PROJNO" CHAR(7), 
	"FDATE" DATE, 
	"TDATE" DATE, 
	"EDATE" DATE, 
	"HOD_CODE" CHAR(5), 
	"HOD_APPRL" NUMBER(1,0), 
	"HOD_APPRL_DT" DATE, 
	"IT_APPRL_DT" DATE, 
	"ISSUEDATE" DATE, 
	"SOFTLIST" VARCHAR2(200), 
	"REMARKS" VARCHAR2(200), 
	"BARCODE" VARCHAR2(13), 
	"RETURNDATE" DATE
   ) ;
