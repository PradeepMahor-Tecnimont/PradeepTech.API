--------------------------------------------------------
--  DDL for Table STK_USER_MASTER
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."STK_USER_MASTER" 
   (	"EMPNO" VARCHAR2(5), 
	"ADMIN_ROLE" NUMBER(1,0) DEFAULT 0, 
	"STOCK_ROLE" NUMBER(1,0) DEFAULT 0, 
	"BLUE_BEAM_ROLE" NUMBER(1,0) DEFAULT 0, 
	"PHONE_EXTENSION" NUMBER(1,0) DEFAULT 0, 
	"EMP_ROLE" VARCHAR2(20)
   ) ;
