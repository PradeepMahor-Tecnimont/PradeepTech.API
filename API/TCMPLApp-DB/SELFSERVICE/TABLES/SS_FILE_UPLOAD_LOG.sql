--------------------------------------------------------
--  DDL for Table SS_FILE_UPLOAD_LOG
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_FILE_UPLOAD_LOG" 
   (	"FILENAME" CHAR(60 BYTE), 
	"FILE_UP_DATE" DATE, 
	"DESCRIPTION" VARCHAR2(60 BYTE), 
	"KEY" CHAR(60 BYTE), 
	"ISDELETED" NUMBER(1,0) DEFAULT 0, 
	"DEL_DATE" DATE, 
	"TRANS_DATE" DATE, 
	"DEL_REASON" VARCHAR2(100 BYTE), 
	"ISERR" NUMBER(1,0), 
	"ERR_DESC" VARCHAR2(500 BYTE), 
	"CLIENT_FILE_NAME" VARCHAR2(60 BYTE), 
	"UPLOAD_CODE" CHAR(4 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
