--------------------------------------------------------
--  DDL for Table ST_ITEM_REQUESTS
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."ST_ITEM_REQUESTS" 
   (	"REQ_ID" NUMBER, 
	"ITEM_CODE" VARCHAR2(20), 
	"QTY" NUMBER(4,0), 
	"REQUEST_DATE" DATE, 
	"ITEM_CATG_ID" NUMBER, 
	"REQUESTER_ENGR" VARCHAR2(5), 
	"REMARKS" VARCHAR2(200), 
	"PRINT_COUNTER" NUMBER(8,0), 
	"REF_OBJECT" VARCHAR2(20)
   ) ;
