--------------------------------------------------------
--  DDL for Table ST_STOCK_IN
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."ST_STOCK_IN" 
   (	"IN_ID" NUMBER, 
	"ITEM_ID" NUMBER, 
	"IN_DATE" DATE, 
	"REMARKS" VARCHAR2(100), 
	"MODIFIED_ON" DATE, 
	"QTY" NUMBER(5,0), 
	"INV_NO" VARCHAR2(30), 
	"INV_DATE" DATE, 
	"RECD_BY" VARCHAR2(5), 
	"RECD_DT" DATE, 
	"VENDOR" VARCHAR2(60)
   ) ;
