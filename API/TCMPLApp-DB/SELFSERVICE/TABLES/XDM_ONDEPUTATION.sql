--------------------------------------------------------
--  DDL for Table XDM_ONDEPUTATION
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."XDM_ONDEPUTATION" 
   (	"EMPNO" CHAR(5 BYTE), 
	"LOCATION" VARCHAR2(50 BYTE), 
	"PROJECT" VARCHAR2(50 BYTE), 
	"FROMDATE" DATE, 
	"TODATE" DATE, 
	"RECBY" CHAR(5 BYTE), 
	"RECDATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
