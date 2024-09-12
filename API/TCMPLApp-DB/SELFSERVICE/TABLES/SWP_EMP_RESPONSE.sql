--------------------------------------------------------
--  DDL for Table SWP_EMP_RESPONSE
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SWP_EMP_RESPONSE" 
   (	"EMPNO" CHAR(5 BYTE), 
	"IS_ACCEPTED" VARCHAR2(2 BYTE), 
	"EMP_ENTRY_DATE" DATE, 
	"HOD_APPRL" VARCHAR2(2 BYTE), 
	"HOD_APPRL_BY" VARCHAR2(5 BYTE), 
	"HOD_APPRL_DATE" DATE, 
	"HR_APPRL" VARCHAR2(2 BYTE), 
	"HR_APPRL_BY" VARCHAR2(5 BYTE), 
	"HR_APPRL_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
  GRANT UPDATE ON "SELFSERVICE"."SWP_EMP_RESPONSE" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "SELFSERVICE"."SWP_EMP_RESPONSE" TO "TCMPL_APP_CONFIG";
  GRANT INSERT ON "SELFSERVICE"."SWP_EMP_RESPONSE" TO "TCMPL_APP_CONFIG";
  GRANT DELETE ON "SELFSERVICE"."SWP_EMP_RESPONSE" TO "TCMPL_APP_CONFIG";
