--------------------------------------------------------
--  DDL for Table SS_9794_PUNCH_GENRAT_NO_FOUND
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_9794_PUNCH_GENRAT_NO_FOUND" 
   (	"EMPNO" VARCHAR2(5 BYTE), 
	"P_DATE" DATE, 
	"TIME_SEC" NUMBER, 
	"TIME_CHR" VARCHAR2(20 BYTE), 
	"TID" NUMBER, 
	"IN_OUT" NUMBER, 
	"GATE_NO" VARCHAR2(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
