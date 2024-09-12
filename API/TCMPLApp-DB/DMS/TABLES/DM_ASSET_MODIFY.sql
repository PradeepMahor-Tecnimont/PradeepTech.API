--------------------------------------------------------
--  DDL for Table DM_ASSET_MODIFY
--------------------------------------------------------

  CREATE TABLE "DM_ASSET_MODIFY" 
   (	"REQNUM" VARCHAR2(25), 
	"REQDATE" DATE, 
	"DESKID" VARCHAR2(7), 
	"ASSETTYPE" CHAR(2), 
	"ASEETID_OLD" VARCHAR2(13), 
	"ASSETID_NEW" VARCHAR2(13), 
	"ACTIONCODE" CHAR(1), 
	"ENGG_CODE" CHAR(5), 
	"ITCORD_STATUS" NUMBER(1,0) DEFAULT 0, 
	"ITCORD_CODE" CHAR(5), 
	"ITCORD_DATE" DATE, 
	"ASSETNAME_OLD" VARCHAR2(20), 
	"ASSETNAME_NEW" VARCHAR2(20)
   ) ;

   COMMENT ON COLUMN "DM_ASSET_MODIFY"."ACTIONCODE" IS '"R" - Replace, "A" - Add, "D" - Delete';
   COMMENT ON COLUMN "DM_ASSET_MODIFY"."ITCORD_STATUS" IS '"0" - Pending, "1" - Done';
