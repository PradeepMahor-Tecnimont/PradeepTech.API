--------------------------------------------------------
--  DDL for Table HOLIDAYS
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."HOLIDAYS" 
   (	"SRNO" NUMBER(3,0), 
	"HOLIDAY" DATE, 
	"YYYYMM" CHAR(6 BYTE), 
	"WEEKDAY" VARCHAR2(3 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
