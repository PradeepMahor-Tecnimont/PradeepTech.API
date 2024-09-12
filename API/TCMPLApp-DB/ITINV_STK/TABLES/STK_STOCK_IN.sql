--------------------------------------------------------
--  DDL for Table STK_STOCK_IN
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."STK_STOCK_IN" 
   (	"KEY_ID" VARCHAR2(5), 
	"STK_DATE" DATE, 
	"ITEM_TYPE" VARCHAR2(5), 
	"SUB_ITEM_TYPE" VARCHAR2(5), 
	"QUANTITY" NUMBER(10,0), 
	"MODIFIED_BY" VARCHAR2(50), 
	"MODIFIED_DATE" DATE, 
	"REMARK" VARCHAR2(250)
   ) ;
