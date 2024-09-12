--------------------------------------------------------
--  DDL for Table DM_ACTION_TRANS
--------------------------------------------------------

  CREATE TABLE "DM_ACTION_TRANS" 
   (	"ACTIONTRANSID" CHAR(11), 
	"ASSETID" VARCHAR2(13), 
	"SOURCEDESK" VARCHAR2(5), 
	"TARGETASSET" VARCHAR2(13), 
	"ACTION_TYPE" NUMBER, 
	"REMARKS" VARCHAR2(100), 
	"ACTION_DATE" DATE, 
	"ACTION_BY" VARCHAR2(5), 
	"SOURCE_EMP" VARCHAR2(50), 
	"ASSETID_OLD" VARCHAR2(13)
   ) ;
