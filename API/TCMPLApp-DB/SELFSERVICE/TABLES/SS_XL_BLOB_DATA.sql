--------------------------------------------------------
--  DDL for Table SS_XL_BLOB_DATA
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_XL_BLOB_DATA" 
   (	"KEY_ID" VARCHAR2(8 BYTE), 
	"SHEET_NR" NUMBER(2,0), 
	"SHEET_NAME" VARCHAR2(4000 BYTE), 
	"ROW_NR" NUMBER(10,0), 
	"COL_NR" NUMBER(10,0), 
	"CELL" VARCHAR2(100 BYTE), 
	"CELL_TYPE" VARCHAR2(1 BYTE), 
	"STRING_VAL" VARCHAR2(4000 BYTE), 
	"NUMBER_VAL" NUMBER, 
	"DATE_VAL" DATE, 
	"FORMULA" VARCHAR2(4000 BYTE), 
	"ERR_CODE" VARCHAR2(5 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
  GRANT UPDATE ON "SELFSERVICE"."SS_XL_BLOB_DATA" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "SELFSERVICE"."SS_XL_BLOB_DATA" TO "TCMPL_APP_CONFIG";
  GRANT INSERT ON "SELFSERVICE"."SS_XL_BLOB_DATA" TO "TCMPL_APP_CONFIG";
  GRANT DELETE ON "SELFSERVICE"."SS_XL_BLOB_DATA" TO "TCMPL_APP_CONFIG";
