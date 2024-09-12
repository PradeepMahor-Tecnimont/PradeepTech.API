--------------------------------------------------------
--  DDL for Table SS_HEALTH_BILL
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_HEALTH_BILL" 
   (	"BILLNO" CHAR(6 BYTE), 
	"BILL_DATE" DATE, 
	"REFERENCE" VARCHAR2(200 BYTE), 
	"RATE" NUMBER(8,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
