--------------------------------------------------------
--  DDL for Table XDM_TRAN_HIST_20100416
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."XDM_TRAN_HIST_20100416" 
   (	"MOVEREQNUM" VARCHAR2(18 BYTE), 
	"EMPNO" CHAR(5 BYTE), 
	"DESKID" VARCHAR2(7 BYTE), 
	"DESK_FLAG" CHAR(1 BYTE), 
	"ASSETID" VARCHAR2(20 BYTE), 
	"HISTORYDATE" DATE, 
	"ASSET_TYPE" VARCHAR2(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
