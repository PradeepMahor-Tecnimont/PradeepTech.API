--------------------------------------------------------
--  DDL for Table SS_HEALTH_HRD
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_HEALTH_HRD" 
   (	"APPLNO" CHAR(20 BYTE), 
	"CHKDATE" DATE, 
	"PRNT" NUMBER(1,0) DEFAULT 0, 
	"LTDATE" DATE, 
	"OUTNO" NUMBER(4,0), 
	"YYYY" VARCHAR2(4 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
