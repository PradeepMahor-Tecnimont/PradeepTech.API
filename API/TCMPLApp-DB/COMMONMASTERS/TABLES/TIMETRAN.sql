--------------------------------------------------------
--  DDL for Table TIMETRAN
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."TIMETRAN" 
   (	"YYMM" CHAR(6), 
	"EMPNO" CHAR(5), 
	"COSTCODE" CHAR(4), 
	"PROJNO" CHAR(7), 
	"WPCODE" CHAR(1), 
	"ACTIVITY" CHAR(2), 
	"GRP" CHAR(1), 
	"HOURS" NUMBER(12,2), 
	"OTHOURS" NUMBER(12,2), 
	"COMPANY" CHAR(4) DEFAULT 'TICB', 
	"LOADED" NUMBER(12,2), 
	"YYMM_INV" CHAR(6)
   ) ;
