--------------------------------------------------------
--  DDL for Table SS_CLINIC_DETAIL
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_CLINIC_DETAIL" 
   (	"CLINIC" CHAR(10 BYTE), 
	"LOCATION" VARCHAR2(25 BYTE), 
	"CITY" VARCHAR2(25 BYTE), 
	"STATE" VARCHAR2(25 BYTE), 
	"ADD1" VARCHAR2(100 BYTE), 
	"ADD2" VARCHAR2(100 BYTE), 
	"ADD3" VARCHAR2(100 BYTE), 
	"TITLE" CHAR(10 BYTE), 
	"FIRST_NAME" VARCHAR2(25 BYTE), 
	"LAST_NAME" VARCHAR2(25 BYTE), 
	"EMAIL" VARCHAR2(300 BYTE), 
	"CONTACT" VARCHAR2(40 BYTE), 
	"MOBILE" VARCHAR2(30 BYTE), 
	"FORDEPUTATION" NUMBER(1,0), 
	"STATUS" NUMBER(1,0), 
	"REMOVED" NUMBER(1,0), 
	"UNQID" VARCHAR2(4 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
