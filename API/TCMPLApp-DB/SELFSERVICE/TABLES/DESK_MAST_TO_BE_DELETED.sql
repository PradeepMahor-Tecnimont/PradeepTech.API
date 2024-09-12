--------------------------------------------------------
--  DDL for Table DESK_MAST_TO_BE_DELETED
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."DESK_MAST_TO_BE_DELETED" 
   (	"DESKID" VARCHAR2(10 BYTE), 
	"OFFICE" VARCHAR2(5 BYTE), 
	"FLOOR" VARCHAR2(20 BYTE), 
	"WING" VARCHAR2(20 BYTE), 
	"CABIN" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
