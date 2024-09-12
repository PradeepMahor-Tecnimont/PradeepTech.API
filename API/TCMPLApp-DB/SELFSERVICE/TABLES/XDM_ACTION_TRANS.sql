--------------------------------------------------------
--  DDL for Table XDM_ACTION_TRANS
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."XDM_ACTION_TRANS" 
   (	"ACTIONTRANSID" CHAR(11 BYTE), 
	"ASSETID" VARCHAR2(13 BYTE), 
	"SOURCEDESK" VARCHAR2(5 BYTE), 
	"TARGETASSET" VARCHAR2(13 BYTE), 
	"ACTION_TYPE" NUMBER, 
	"REMARKS" VARCHAR2(100 BYTE), 
	"ACTION_DATE" DATE, 
	"ACTION_BY" VARCHAR2(5 BYTE), 
	"SOURCE_EMP" VARCHAR2(50 BYTE), 
	"BARCODE_OLD" VARCHAR2(13 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
