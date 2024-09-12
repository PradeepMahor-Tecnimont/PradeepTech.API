--------------------------------------------------------
--  DDL for Table DIST_SURFACE_LAPTOP_MAST
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."DIST_SURFACE_LAPTOP_MAST" 
   (	"SAP_ASSET_CODE" NUMBER(8,0), 
	"CURRENT_STATUS" NUMBER(2,0), 
	"EXPECTED_DATE" DATE, 
	"REMARKS" VARCHAR2(200), 
	"ASSIGNED_TO_EMPNO" CHAR(5), 
	"PROBLEM" VARCHAR2(2), 
	"WIFI_MAC_ADDRESS" VARCHAR2(30), 
	"EMP_ASSIGNED_DATE" DATE, 
	"MODIFIED_ON" DATE
   ) ;
