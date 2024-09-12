--------------------------------------------------------
--  DDL for Table EMP_IT_MEDIBILL
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_IT_MEDIBILL" 
   (	"COMPANY" CHAR(4), 
	"YEAR" NUMBER(4,0), 
	"EMPNO" CHAR(5), 
	"BILLNO" VARCHAR2(15), 
	"BILLDATE" DATE, 
	"CHEMIST_NAME" VARCHAR2(40), 
	"AMOUNT" NUMBER(8,2)
   ) ;
