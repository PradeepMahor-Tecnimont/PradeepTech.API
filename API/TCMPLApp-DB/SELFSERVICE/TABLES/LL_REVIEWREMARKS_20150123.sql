--------------------------------------------------------
--  DDL for Table LL_REVIEWREMARKS_20150123
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."LL_REVIEWREMARKS_20150123" 
   (	"LL_NUM" VARCHAR2(20 BYTE), 
	"REMPNO" VARCHAR2(5 BYTE), 
	"RDATE" DATE, 
	"REMARKS" VARCHAR2(400 BYTE), 
	"STATUS" NUMBER(1,0), 
	"CHANGEREQ" VARCHAR2(30 BYTE), 
	"CHANGEDESC" VARCHAR2(200 BYTE), 
	"TARGETDATE" DATE, 
	"TMPREF" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
