--------------------------------------------------------
--  DDL for Table XDM_NEWJOIN_TRANS
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."XDM_NEWJOIN_TRANS" 
   (	"NEWJOINREQNUM" VARCHAR2(18 BYTE), 
	"NEWJOINREQDATE" DATE, 
	"EMPNO" CHAR(5 BYTE), 
	"TARGETDESK" VARCHAR2(7 BYTE), 
	"COSTCODE" CHAR(4 BYTE), 
	"HOD_APPRL" NUMBER(1,0), 
	"HOD_DATE" DATE, 
	"HOD_CODE" CHAR(5 BYTE), 
	"IT_APPRL" NUMBER(1,0), 
	"IT_DATE" DATE, 
	"IT_CODE" CHAR(5 BYTE), 
	"ITCORD_APPRL" NUMBER(1,0), 
	"ITCORD_DATE" DATE, 
	"UIDFLAG" NUMBER(1,0), 
	"MAILFLAG" NUMBER(1,0), 
	"COMP" NUMBER(1,0), 
	"MON1" NUMBER(1,0), 
	"MON2" NUMBER(1,0), 
	"TEL" NUMBER(1,0), 
	"PRINT" NUMBER(1,0), 
	"DESKREQ" NUMBER(1,0), 
	"DESKLOC" VARCHAR2(20 BYTE), 
	"USERID" VARCHAR2(20 BYTE), 
	"MAILID" VARCHAR2(50 BYTE), 
	"DESKSHARE" NUMBER(1,0) DEFAULT 0
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
