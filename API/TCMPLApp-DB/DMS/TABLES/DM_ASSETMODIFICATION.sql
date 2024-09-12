--------------------------------------------------------
--  DDL for Table DM_ASSETMODIFICATION
--------------------------------------------------------

  CREATE TABLE "DM_ASSETMODIFICATION" 
   (	"MOVEREQNUM" VARCHAR2(17), 
	"DESKID" VARCHAR2(7), 
	"FROM_ASSET" VARCHAR2(20), 
	"TO_ASSET" VARCHAR2(20), 
	"REMOVED" NUMBER(1,0), 
	"MODIFY_BY" CHAR(5), 
	"MODIFY_DATE" DATE
   ) ;
