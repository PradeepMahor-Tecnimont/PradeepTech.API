--------------------------------------------------------
--  DDL for Table DM_GUESTMASTER
--------------------------------------------------------

  CREATE TABLE "DM_GUESTMASTER" 
   (	"GNUM" CHAR(5), 
	"GNAME" VARCHAR2(30), 
	"GCOSTCODE" CHAR(4), 
	"GPROJNUM" CHAR(7), 
	"GFROMDATE" DATE, 
	"GTODATE" DATE, 
	"GDATE" DATE, 
	"HOD_APPRL" NUMBER(1,0), 
	"HOD_CODE" CHAR(5), 
	"HOD_DATE" DATE, 
	"IT_APPRL" NUMBER(1,0), 
	"IT_CODE" CHAR(5), 
	"IT_DATE" DATE, 
	"ITCORD_APPRL" NUMBER(1,0), 
	"ITCORD_DATE" DATE, 
	"TARGETDESK" VARCHAR2(7), 
	"COMP" NUMBER(1,0), 
	"MON1" NUMBER(1,0), 
	"MON2" NUMBER(1,0), 
	"TEL" NUMBER(1,0), 
	"PRINT" NUMBER(1,0), 
	"DESKREQ" NUMBER(1,0), 
	"DESKLOC" VARCHAR2(20), 
	"GMODDATE" DATE, 
	"GMODBY" CHAR(5), 
	"DESKSHARE" NUMBER(1,0) DEFAULT 0
   ) ;
