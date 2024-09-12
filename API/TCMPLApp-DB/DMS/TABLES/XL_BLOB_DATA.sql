--------------------------------------------------------
--  DDL for Table XL_BLOB_DATA
--------------------------------------------------------

  CREATE TABLE "XL_BLOB_DATA" 
   (	"KEY_ID" NUMBER, 
	"SHEET_NR" NUMBER(2,0), 
	"SHEET_NAME" VARCHAR2(4000), 
	"ROW_NR" NUMBER(10,0), 
	"COL_NR" NUMBER(10,0), 
	"CELL" VARCHAR2(100), 
	"CELL_TYPE" VARCHAR2(1), 
	"STRING_VAL" VARCHAR2(4000), 
	"NUMBER_VAL" NUMBER, 
	"DATE_VAL" DATE, 
	"FORMULA" VARCHAR2(4000)
   ) ;
