--------------------------------------------------------
--  DDL for Table SS_DESKASSIGNMENT
--------------------------------------------------------

  CREATE TABLE "SS_DESKASSIGNMENT" 
   (	"EMPNO" CHAR(5), 
	"LOGINID" VARCHAR2(20), 
	"OFFLOC" CHAR(2), 
	"DESKID" CHAR(7), 
	"TFORCE" CHAR(2), 
	"SHFT" CHAR(1), 
	"COMPNAME" VARCHAR2(20), 
	"PCCODE" VARCHAR2(20), 
	"PCMOD" CHAR(2), 
	"M1CODE" VARCHAR2(20), 
	"M1MOD" CHAR(2), 
	"M2CODE" VARCHAR2(20), 
	"M2MOD" CHAR(2), 
	"TELNO" VARCHAR2(10), 
	"TELCODE" VARCHAR2(20), 
	"TMOD" CHAR(2), 
	"UPDATE_FLAG" NUMBER(38,0), 
	"DESKID_OLD" CHAR(7), 
	"DESKID_1" CHAR(7), 
	"TRANS_DATE" DATE, 
	"FLAG_APPRD" NUMBER(1,0), 
	"LOG_FILE" VARCHAR2(200)
   ) ;
