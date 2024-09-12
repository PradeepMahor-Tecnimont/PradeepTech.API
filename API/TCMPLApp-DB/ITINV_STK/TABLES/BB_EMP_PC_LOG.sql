--------------------------------------------------------
--  DDL for Table BB_EMP_PC_LOG
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."BB_EMP_PC_LOG" 
   (	"KEY_ID" VARCHAR2(5), 
	"EMPNO" VARCHAR2(5), 
	"PCNAME" VARCHAR2(30), 
	"DELETE_FLAG" NUMBER(1,0), 
	"MODIFIED_ON" DATE, 
	"PROJECT" VARCHAR2(30), 
	"INSTALL_DATE" DATE, 
	"UNINSTALL_DATE" DATE, 
	"STATUS" NUMBER(1,0), 
	"FORCE_PROXY" NUMBER(1,0), 
	"REMARKS" VARCHAR2(60), 
	"PDF_WRITER" NUMBER(1,0), 
	"VERSION" VARCHAR2(60)
   ) ;
  GRANT SELECT ON "ITINV_STK"."BB_EMP_PC_LOG" TO "SELFSERVICE";
