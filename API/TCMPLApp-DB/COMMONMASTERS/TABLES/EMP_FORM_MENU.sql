--------------------------------------------------------
--  DDL for Table EMP_FORM_MENU
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_FORM_MENU" 
   (	"ID" NUMBER(5,0), 
	"LABEL" VARCHAR2(60), 
	"ICON" VARCHAR2(60), 
	"MASTER" NUMBER(5,0), 
	"STATUS" NUMBER(1,0) DEFAULT 1, 
	"VALUE" VARCHAR2(60), 
	"ACCESS_TYPE" VARCHAR2(5), 
	"SORT_ORDER" VARCHAR2(3)
   ) ;
