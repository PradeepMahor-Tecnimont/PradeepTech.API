--------------------------------------------------------
--  DDL for Table SEC_MODULE_DELEGATE
--------------------------------------------------------
 
  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_DELEGATE" 
   (	"MODULE_ID" CHAR(3 BYTE) NOT NULL ENABLE, 
	"PRINCIPAL_EMPNO" CHAR(5 BYTE) NOT NULL ENABLE, 
	"ON_BEHALF_EMPNO" CHAR(5 BYTE) NOT NULL ENABLE, 
	"MODIFIED_BY" CHAR(5 BYTE) NOT NULL ENABLE, 
	"MODIFIED_ON" DATE NOT NULL ENABLE, 
	 CONSTRAINT "SEC_MODULE_DELEGATE_PK" PRIMARY KEY ("ON_BEHALF_EMPNO", "PRINCIPAL_EMPNO", "MODULE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "SEC_MODULE_DELEGATE_FK1" FOREIGN KEY ("MODULE_ID")
	  REFERENCES "TCMPL_APP_CONFIG"."SEC_MODULES" ("MODULE_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;


  GRANT SELECT ON "TCMPL_APP_CONFIG"."SEC_MODULE_DELEGATE" TO "TIMECURR";
