--------------------------------------------------------
--  DDL for Table DM_DESKALLOCATION_LOG
--------------------------------------------------------

  CREATE TABLE "DM_DESKALLOCATION_LOG" 
   (	"DESKID" VARCHAR2(7), 
	"ASSETID" VARCHAR2(20), 
	"FLAG" CHAR(1), 
	"LOG_DATE" DATE, 
	"ASSET_TYPE" VARCHAR2(2), 
	"REMARK" VARCHAR2(20), 
	"TRANS_ID" CHAR(11)
   ) ;

   COMMENT ON COLUMN "DM_DESKALLOCATION_LOG"."FLAG" IS 'I = Insert; D = Deelete';
