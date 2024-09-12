--------------------------------------------------------
--  DDL for Table DM_ASSET_OUT_OF_USE_LOG
--------------------------------------------------------

  CREATE TABLE "DM_ASSET_OUT_OF_USE_LOG" 
   (	"BARCODE" VARCHAR2(20), 
	"OLD_SCRAP_VAL" NUMBER(1,0), 
	"OLD_SCRAP_DATE" DATE, 
	"OLD_OUT_OF_SRV" NUMBER(1,0), 
	"NU_SCRAP_VAL" NUMBER(1,0), 
	"NU_SCRAP_DATE" DATE, 
	"NU_OUT_OF_SRV" NUMBER(1,0), 
	"LOG_DATE" DATE, 
	"TRANS_ID" CHAR(11), 
	"ASSET_TYPE" VARCHAR2(20)
   ) ;
