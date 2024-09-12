--------------------------------------------------------
--  DDL for Table AD_TEMP
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."AD_TEMP" 
   (	"EMPNO" VARCHAR2(5 BYTE), 
	"LOCATION" VARCHAR2(20 BYTE), 
	"TELEXTN" VARCHAR2(10 BYTE), 
	"MOBILE" VARCHAR2(10 BYTE), 
	"REMARKS" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
