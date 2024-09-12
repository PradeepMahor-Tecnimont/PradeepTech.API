--------------------------------------------------------
--  DDL for Table DM_ASSETMOVE_TRAN
--------------------------------------------------------

  CREATE TABLE "DM_ASSETMOVE_TRAN" 
   (	"MOVEREQNUM" VARCHAR2(18), 
	"MOVEREQDATE" DATE, 
	"EMPNO" CHAR(5), 
	"CURRDESK" VARCHAR2(7), 
	"TARGETDESK" VARCHAR2(7), 
	"IT_APPRL" NUMBER(1,0), 
	"IT_CODE" CHAR(5), 
	"IT_DATE" DATE, 
	"IT_CORD_APPRL" NUMBER(1,0), 
	"IT_CORD_DATE" DATE, 
	"ASSETFLAG" NUMBER(1,0) DEFAULT 0, 
	"EMPFLAG" NUMBER(1,0) DEFAULT 0, 
	"COMP" NUMBER(1,0), 
	"MON1" NUMBER(1,0), 
	"MON2" NUMBER(1,0), 
	"TEL" NUMBER(1,0), 
	"PRINT" NUMBER(1,0), 
	"DESKREQ" NUMBER(1,0), 
	"DESKLOC" VARCHAR2(20)
   ) ;
