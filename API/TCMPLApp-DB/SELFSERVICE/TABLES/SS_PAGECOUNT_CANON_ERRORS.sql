--------------------------------------------------------
--  DDL for Table SS_PAGECOUNT_CANON_ERRORS
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_PAGECOUNT_CANON_ERRORS" 
   (	"ENTRY_DATE" VARCHAR2(14 BYTE), 
	"IPADDRESS" VARCHAR2(15 BYTE), 
	"PRN_QUEUE" VARCHAR2(500 BYTE), 
	"SRNO" VARCHAR2(15 BYTE), 
	"HOSTNAME" VARCHAR2(15 BYTE), 
	"PRN_NAME" VARCHAR2(100 BYTE), 
	"PRN_ONLINE" NUMBER(1,0), 
	"OFFICE" VARCHAR2(4 BYTE), 
	"FLOOR" VARCHAR2(20 BYTE), 
	"WING" VARCHAR2(15 BYTE), 
	"TOTAL" NUMBER(10,0), 
	"BLACKLARGE" NUMBER(10,0), 
	"BLACKSMALL" NUMBER(10,0), 
	"COLORLARGE" NUMBER(10,0), 
	"COLORSMALL" NUMBER(10,0), 
	"TOTAL2SIDED" NUMBER(10,0), 
	"TOTAL2" NUMBER(10,0), 
	"TOTAL_DAILY" NUMBER(10,0), 
	"BLACKLARGE_DAILY" NUMBER(10,0), 
	"BLACKSMALL_DAILY" NUMBER(10,0), 
	"COLORLARGE_DAILY" NUMBER(10,0), 
	"COLORSMALL_DAILY" NUMBER(10,0), 
	"TOTAL2SIDED_DAILY" NUMBER(10,0), 
	"TOTAL2_DAILY" NUMBER(10,0), 
	"MANUAL_ENTRY_ID" NUMBER(10,0), 
	"LOCATION" VARCHAR2(100 BYTE), 
	"TOTAL_DAILY_SRNO" NUMBER(10,0), 
	"BLACKLARGE_DAILY_SRNO" NUMBER(10,0), 
	"BLACKSMALL_DAILY_SRNO" NUMBER(10,0), 
	"COLORLARGE_DAILY_SRNO" NUMBER(10,0), 
	"COLORSMALL_DAILY_SRNO" NUMBER(10,0), 
	"TOTAL2SIDED_DAILY_SRNO" NUMBER(10,0), 
	"TOTAL2_DAILY_SRNO" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
