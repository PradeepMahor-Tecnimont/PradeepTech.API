--------------------------------------------------------
--  DDL for Table XDM_EMP_LEFT_DEL
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."XDM_EMP_LEFT_DEL" 
   (	"DELBY" CHAR(5 BYTE), 
	"DELDATE" DATE, 
	"EMPNO" CHAR(5 BYTE), 
	"DOL" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
