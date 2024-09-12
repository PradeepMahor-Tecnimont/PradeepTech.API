--------------------------------------------------------
--  DDL for Table SS_ABSENT_TS_LOP_REVERSE
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_ABSENT_TS_LOP_REVERSE" 
   (	"EMPNO" CHAR(5 BYTE), 
	"LOP_4_DATE" DATE, 
	"PAYSLIP_YYYYMM" VARCHAR2(6 BYTE), 
	"HALF_FULL" NUMBER(3,1), 
	"ENTRY_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
