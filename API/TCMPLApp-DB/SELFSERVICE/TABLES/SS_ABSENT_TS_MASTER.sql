--------------------------------------------------------
--  DDL for Table SS_ABSENT_TS_MASTER
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_ABSENT_TS_MASTER" 
   (	"ABSENT_YYYYMM" VARCHAR2(6 BYTE), 
	"PAYSLIP_YYYYMM" VARCHAR2(6 BYTE), 
	"MODIFIED_ON" DATE, 
	"MODIFIED_BY" VARCHAR2(5 BYTE), 
	"KEY_ID" VARCHAR2(8 BYTE), 
	"REFRESHED_ON" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
