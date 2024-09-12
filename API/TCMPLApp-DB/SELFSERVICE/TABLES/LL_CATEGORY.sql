--------------------------------------------------------
--  DDL for Table LL_CATEGORY
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."LL_CATEGORY" 
   (	"CODE" VARCHAR2(2 BYTE), 
	"COSTCODE" VARCHAR2(4 BYTE), 
	"CATEGORYID" VARCHAR2(3 BYTE), 
	"CATEGORY" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
