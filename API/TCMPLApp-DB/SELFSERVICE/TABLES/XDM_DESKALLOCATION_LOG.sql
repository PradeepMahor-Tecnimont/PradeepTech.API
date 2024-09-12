--------------------------------------------------------
--  DDL for Table XDM_DESKALLOCATION_LOG
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."XDM_DESKALLOCATION_LOG" 
   (	"DESKID" VARCHAR2(7 BYTE), 
	"ASSETID" VARCHAR2(20 BYTE), 
	"FLAG" CHAR(1 BYTE), 
	"LOG_DATE" DATE, 
	"ASSET_TYPE" VARCHAR2(2 BYTE), 
	"REMARK" VARCHAR2(20 BYTE), 
	"TRANS_ID" CHAR(11 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;

   COMMENT ON COLUMN "SELFSERVICE"."XDM_DESKALLOCATION_LOG"."FLAG" IS 'I = Insert; D = Deelete';
