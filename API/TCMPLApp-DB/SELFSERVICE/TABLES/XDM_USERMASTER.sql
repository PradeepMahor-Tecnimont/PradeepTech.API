--------------------------------------------------------
--  DDL for Table XDM_USERMASTER
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."XDM_USERMASTER" 
   (	"EMPNO" CHAR(5 BYTE), 
	"DESKID" VARCHAR2(7 BYTE), 
	"COSTCODE" CHAR(4 BYTE), 
	"DEP_FLAG" NUMBER(1,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
