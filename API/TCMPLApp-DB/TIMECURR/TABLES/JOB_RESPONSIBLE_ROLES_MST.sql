
  CREATE TABLE "TIMECURR"."JOB_RESPONSIBLE_ROLES_MST" 
   (	"JOB_RESPONSIBLE_ROLE_ID" VARCHAR2(3 BYTE) NOT NULL ENABLE, 
	"JOB_RESPONSIBLE_ROLE_NAME" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"IS_ACTIVE" NUMBER(1,0) DEFAULT 1 NOT NULL ENABLE, 
	"IS_APPROVER" NUMBER(1,0) DEFAULT 0, 
	"APP_CONFIG_ROLE_ID" VARCHAR2(4 BYTE), 
	"APP_CONFIG_ON_BEHALF_ROLE_ID" VARCHAR2(4 BYTE), 
	 CONSTRAINT "JOB_RESPONSIBLE_ROLES_MST_UK1" UNIQUE ("JOB_RESPONSIBLE_ROLE_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "JOB_RESPONSIBLE_ROLES_MST_PK" PRIMARY KEY ("JOB_RESPONSIBLE_ROLE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
  
  COMMENT ON COLUMN "TIMECURR"."JOB_RESPONSIBLE_ROLES_MST"."IS_ACTIVE" IS '1 or 0';
  COMMENT ON COLUMN "TIMECURR"."JOB_RESPONSIBLE_ROLES_MST"."IS_APPROVER" IS '0 or 1';

  GRANT SELECT ON "TIMECURR"."JOB_RESPONSIBLE_ROLES_MST" TO "TCMPL_APP_CONFIG";

