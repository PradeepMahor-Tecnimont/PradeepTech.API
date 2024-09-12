--------------------------------------------------------
--  DDL for Table VPP_VOLUNTARY_PARENT_POLICY
--------------------------------------------------------

 
 CREATE TABLE "TCMPL_HR"."VPP_VOLUNTARY_PARENT_POLICY" 
   (	"KEY_ID" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
	"EMPNO" VARCHAR2(5 BYTE) NOT NULL ENABLE, 
	"INSURED_SUM_ID" VARCHAR2(3 BYTE) NOT NULL ENABLE, 
	"MODIFIED_ON" DATE NOT NULL ENABLE, 
	"MODIFIED_BY" VARCHAR2(5 BYTE) NOT NULL ENABLE, 
	 CONSTRAINT "VPP_VOLUNTARY_PARENT_POLIC_PK" PRIMARY KEY ("KEY_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "VPP_VOLUNTARY_PARENT_POLI_UK1" UNIQUE ("EMPNO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "VPP_VOLUNTARY_PARENT_POLI_FK1" FOREIGN KEY ("INSURED_SUM_ID")
	  REFERENCES "TCMPL_HR"."VPP_INSURED_SUM_MASTER" ("INSURED_SUM_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;

  GRANT UPDATE ON "TCMPL_HR"."VPP_VOLUNTARY_PARENT_POLICY" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "TCMPL_HR"."VPP_VOLUNTARY_PARENT_POLICY" TO "TCMPL_APP_CONFIG";
  GRANT INSERT ON "TCMPL_HR"."VPP_VOLUNTARY_PARENT_POLICY" TO "TCMPL_APP_CONFIG";
  GRANT DELETE ON "TCMPL_HR"."VPP_VOLUNTARY_PARENT_POLICY" TO "TCMPL_APP_CONFIG";
