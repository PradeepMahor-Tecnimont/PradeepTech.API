--------------------------------------------------------
--  DDL for Table SS_PRINT_RATE_MAST
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_PRINT_RATE_MAST" 
   (	"PAGE_SIZE" VARCHAR2(2 BYTE), 
	"COLOR" NUMBER(1,0), 
	"RATE" NUMBER(5,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
