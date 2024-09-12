--------------------------------------------------------
--  DDL for Table AFC_CURRENCIES
--------------------------------------------------------

  CREATE TABLE "AFC_CURRENCIES" 
   (	"CURRENCY_KEY_ID" CHAR(4 BYTE), 
	"CURRENCY_CODE" VARCHAR2(3 BYTE), 
	"CURRENCY_DESC" VARCHAR2(100 BYTE), 
	"IS_ACTIVE" NUMBER(1,0)
   ) ;
