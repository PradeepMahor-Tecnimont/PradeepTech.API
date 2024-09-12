--------------------------------------------------------
--  DDL for Table SS_GUEST_REGISTER
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_GUEST_REGISTER" 
   (	"APP_NO" CHAR(16 BYTE), 
	"HOST_NAME" VARCHAR2(60 BYTE), 
	"GUEST_NAME" VARCHAR2(250 BYTE), 
	"GUEST_CO" VARCHAR2(60 BYTE), 
	"MEET_DATE" DATE, 
	"MEET_OFF" VARCHAR2(4 BYTE), 
	"REMARKS" VARCHAR2(60 BYTE), 
	"MODIFIED_BY" VARCHAR2(5 BYTE), 
	"MODIFIED_ON" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
  GRANT UPDATE ON "SELFSERVICE"."SS_GUEST_REGISTER" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "SELFSERVICE"."SS_GUEST_REGISTER" TO "TCMPL_APP_CONFIG";
  GRANT INSERT ON "SELFSERVICE"."SS_GUEST_REGISTER" TO "TCMPL_APP_CONFIG";
  GRANT DELETE ON "SELFSERVICE"."SS_GUEST_REGISTER" TO "TCMPL_APP_CONFIG";
