--------------------------------------------------------
--  DDL for Table DIST_LAPTOP_STATUS_LOG_DEL
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."DIST_LAPTOP_STATUS_LOG_DEL" 
   (	"AMS_ASSET_ID" VARCHAR2(30), 
	"CURRENT_STATUS" NUMBER(2,0), 
	"EXPECTED_DATE" DATE, 
	"REMARKS" VARCHAR2(200), 
	"ASSIGNED_TO_EMPNO" CHAR(5), 
	"PROBLEM" VARCHAR2(2), 
	"WIFI_MAC_ADDRESS" VARCHAR2(30), 
	"EMP_ASSIGNED_DATE" DATE, 
	"MODIFIED_ON" DATE, 
	"DELETED_ON" DATE
   ) ;
