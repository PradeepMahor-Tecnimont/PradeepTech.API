
  CREATE TABLE "TIMECURR"."JOB_RESPONSIBLE_ROLES" 
   (	"PROJNO5" VARCHAR2(5 BYTE) NOT NULL ENABLE, 
	"JOB_RESPONSIBLE_ROLE_ID" VARCHAR2(3 BYTE) NOT NULL ENABLE, 
	"EMPNO" CHAR(5 BYTE), 
	"HAS_APPROVED" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	"MODIFIED_BY" CHAR(5 BYTE), 
	"MODIFIED_ON" DATE, 
	 CONSTRAINT "JOB_RESPONSIBLE_ROLES_PK" PRIMARY KEY ("PROJNO5", "JOB_RESPONSIBLE_ROLE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "JOB_RESPONSIBLE_ROLES_FK1" FOREIGN KEY ("JOB_RESPONSIBLE_ROLE_ID")
	  REFERENCES "TIMECURR"."JOB_RESPONSIBLE_ROLES_MST" ("JOB_RESPONSIBLE_ROLE_ID") ENABLE, 
	 CONSTRAINT "JOB_RESPONSIBLE_ROLES_FK2" FOREIGN KEY ("EMPNO")
	  REFERENCES "TIMECURR"."EMPLMAST" ("EMPNO") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;

   COMMENT ON COLUMN "TIMECURR"."JOB_RESPONSIBLE_ROLES"."HAS_APPROVED" IS '0 or 1';

