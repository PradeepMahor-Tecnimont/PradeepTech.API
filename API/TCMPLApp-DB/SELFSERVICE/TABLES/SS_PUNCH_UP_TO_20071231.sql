--------------------------------------------------------
--  DDL for Table SS_PUNCH_UP_TO_20071231
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_PUNCH_UP_TO_20071231" 
   (	"EMPNO" CHAR(5 BYTE), 
	"HH" NUMBER(2,0), 
	"MM" NUMBER(2,0), 
	"PDATE" DATE, 
	"FALSEFLAG" NUMBER(1,0), 
	"DD" CHAR(2 BYTE), 
	"MON" CHAR(2 BYTE), 
	"YYYY" CHAR(4 BYTE), 
	"MACH" CHAR(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
